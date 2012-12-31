require 'rest_client'
require 'oj'
require 'yaml'
class EspnApi

  attr_accessor :sport, :uri, :config, :api_key, :teams_data, :league, :league_name

  # http://api.espn.com/v1/sports/baseball/mlb
  # http://api.espn.com/v1/sports/football/nfl
  # http://api.espn.com/v1/sports/basketball/nba
  ESPN_URL = "http://api.espn.com/v1/sports/"
  URI_BY_SPORT = {
    'baseball' => ESPN_URL + "baseball/mlb",
    'football' => ESPN_URL + "football/nfl",
    'basketball' => ESPN_URL + "basketball/nba",
    'college_basketball' => ESPN_URL + "basketball/mens-college-basketball",
  }

  def initialize(sport_name, league_name)
    @sport = Sport.where(:name => sport_name.titleize).first_or_create
    @league_name = league_name

    load_sport_data
    load_league_data

    @league = sport.leagues.where(:name => league_name, :abbreviation => league_data['abbreviation']).first_or_create
    @uri = URI_BY_SPORT[sport_name]
  end

  def api_url(path, query_params = {})
    query_params['apikey'] = api_key
    query_string = query_params.to_a.map{|key_values| key_values.join("=")}.join("&")
    "#{uri}/#{path}?#{query_string}"
  end

  def config
    @config = YAML.load_file("config/espn.yml")
  end

  def api_key
    config['api_key']
  end

  def shared_secret
    config['shared_secret']
  end

  def sport_data
    return @sport_data if @sport_data
    @sport_data = load_sport_data
    @sport_data
  end

  def load_sport_data
    json = Oj.load_file(File.join(Rails.root, 'db', 'data', "#{league_name}.json"))
    json['sports'].detect{|s| s['name'] == sport.name.downcase }
  end

  def league_data
    return @league_data if @league_data
    @league_data = load_league_data
    @league_data
  end

  def load_league_data
    sport_data['leagues'].detect{|l| l['abbreviation'] == league_name }
  end

  def teams_in_group(group_id)
    local_file = File.join(Rails.root, 'db', 'data', "teams_group_#{group_id}.json")
    if File.exists?(local_file)
      Oj.load_file(local_file)['sports'].first['leagues'].first['teams']
    else
      data = RestClient.get api_url("teams", {"groups" => group_id})
      Oj.load(data)['sports'].first['leagues'].first['teams']
    end
  end

  def teams_data
    return @teams_data if @teams_data

    teams_json = RestClient.get api_url("teams")
    @teams_data = Oj.load(teams_json)['sports'].first['leagues'].first['teams']
    @teams_data
  end

#    divisions = %w(North South East West)
#    divisions.each do |division_name|
#      nfc.divisions.where(:name => division_name).first_or_create
#      afc.divisions.where(:name => division_name).first_or_create
#    end
  def load_league
    puts "#{league.abbreviation}: creating #{league_data['groups'].size} conferences"
    league_data['groups'].each do |conf_data|
      conference = league.conferences.where(:name => conf_data['name'], :abbreviation => conf_data['abbreviation']).first_or_create
      puts "#{conference.abbreviation}: creating #{conf_data['groups'].size} divisions"
      conf_data['groups'].each do |gd|
        division = conference.divisions.where(:name => gd['name'], :abbreviation => gd['abbreviation'], :espn_group => gd['groupId']).first_or_create
        teams = teams_in_group(division.espn_group)
        if teams.any?
          puts "\t#{teams.size} teams found"
          teams.each do |team_data|
            team_data['division_id'] = division.id
            team_data['conference_id'] = conference.id
            load_team(team_data)
          end
        else
          puts "\tFailed finding any teams:("
        end
      end
    end
  end

  #attr_accessible :name, :abbreviation, :location, :sport, :league, :conference, :division, :color, :source, :source_id
  #validates_presence_of :name, :abbreviation, :location, :sport, :league
  def load_team(data)
      team = Team.where(:sport_id => sport.id, :league_id => league.id, :name => data['name'], :abbreviation => data['abbreviation'], :location => data['location']).first_or_create
      team.update_attributes(:color => data['color'], :conference_id => data['conference_id'], :division_id => data['division_id'],
                             :source_id => data['id'],
                             :source => 'api.espn.com')

  end

  def load_teams(divisions)
    teams_data.each do |team_data|
      team = Team.where(:sport => sport,
                        :league => league,
                        :name => team_data['name'],
                        :abbreviation => team_data['abbreviation'],
                        :location => team_data['location']).first_or_create
      team.update_attributes(:color => team_data['color'],
                             :source_id => team_data['id'],
                             :source => 'api.espn.com')
    end
  end
end

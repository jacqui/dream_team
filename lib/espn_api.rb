require 'rest_client'
require 'oj'
require 'yaml'
class EspnApi

  attr_accessor :sport, :uri, :config, :api_key, :teams_data

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

  def initialize(sport)
    @sport = sport
    @uri = URI_BY_SPORT[sport]
  end

  def api_url(path)
    "#{uri}/#{path}?apikey=#{api_key}"
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

  def teams_data
    return @teams_data if @teams_data

    teams_json = RestClient.get api_url("teams")
    @teams_data = Oj.load(teams_json)['sports'].first['leagues'].first['teams']
    @teams_data
  end

  def load_teams
    teams_data.each do |team_data|
      team = Team.where(:name => team_data['name'], :abbreviation => team_data['abbreviation'], :location => team_data['location']).first_or_create
      team.update_attributes(:color => team_data['color'],
                             :web_link => team_data['links']['web']['teams']['href'],
                             :api_link => team_data['links']['api']['teams']['href'],
                             :news_api_link => team_data['links']['api']['news']['href'],
                             :notes_api_link => team_data['links']['api']['notes']['href'],
                             :mobile_link => team_data['links']['mobile']['teams']['href'])
    end
  end

  def players(team)
  end


end
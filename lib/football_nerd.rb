require 'open-uri'
require 'nokogiri'
require 'yaml'
class FootballNerd

  attr_accessor :config, :api_key, :base_url

  def initialize
    @base_url = "http://api.fantasyfootballnerd.com/"
    @api_key = config["api_key"]
  end

  def config
    @config = YAML.load_file("config/football_nerd.yml")
  end

  def parse_xml(path)
    url = URI.join(base_url, path) + "?apiKey=#{api_key}"
    Nokogiri::XML open(url)
  end

  def load_players
    doc = parse_xml("ffnPlayersXML.php")
    player_nodes = doc.search("Player")
    missing_teams = []

    player_nodes.each do |node|
      if team = Team.find_by_abbreviation(node['Team'])
        player = Player.new(:team => team, :full_name => node['Name'], :position => node['Position'], :source_id => node['playerId'], :source => "api.fantasyfootballnerd.com")
        player.save!
        puts "Saved: #{[team.name, player.full_name].join(": ")}"
      else
        missing_teams << node['Team']
      end
    end
    missing_teams.uniq!
    missing_teams.sort!

    puts "Current player count is #{Player.count} in #{Player.uniq.pluck(:team_id).count} teams."
    if missing_teams.any?
      puts "Sorry, I was unable to find the following teams by abbreviation in our database: #{missing_teams.join(', ')}."
    end
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'espn_api'
require 'football_nerd'

Team.destroy_all
Player.destroy_all

puts "Loading teams from the ESPN API..."
espn = EspnApi.new('football')
espn.load_teams
puts "Done loading teams from the ESPN API. We now have #{Team.count} teams stored!"

puts "Loading players from the Football Nerd API..."
nerd = FootballNerd.new
nerd.load_players
puts "Done loading players from the Football Nerd API. We now have #{Player.count} players stored!"

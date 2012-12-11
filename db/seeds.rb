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
Pick.destroy_all
PickWindow.destroy_all
PickBucket.destroy_all

puts "Loading teams from the ESPN API..."
espn = EspnApi.new('football')
espn.load_teams
# espn.load_players

puts "Done loading teams from the ESPN API. We now have #{Team.count} teams stored!"

puts "Loading players from the Football Nerd API..."
nerd = FootballNerd.new
nerd.load_players
puts "Done loading players from the Football Nerd API. We now have #{Player.count} players stored!"

Project.create(:name => "Super Bowl 2013", :slug => "super-bowl-2013")
project = Project.find_by_slug('super-bowl-2013')

if project.current_pick_window.nil?
  PickWindow.create(:project_id => project.id, :window_start => Date.yesterday.to_datetime, :window_end => (Date.today + 2.weeks).to_datetime)
end

PickWindow.all.each do |window|
  %w(QB RB WR).each_with_index do |pick_type, idx|
    PickBucket.create(
      :pick_window_id => window.id,
      :pick_type => pick_type,
      :count => 1, # idx + 1,
      :required => true
    )
  end
end

if Reader.count == 0
  Reader.find_or_create_by_name("Michael Strickland")
end


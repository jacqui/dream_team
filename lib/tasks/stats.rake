namespace :stats do
  desc "scrape nytimes.stats.com for given team stats"
  task :run => :environment do
    ids = ENV['TEAMIDS']
    id1, id2 = ids.split(",").map(&:strip)

    puts "Scraping data for team id#: #{id1}"
    stat1 = Stats.new('team1', :team_id => id1)

    puts "Scraping data for team id#: #{id2}"
    stat2 = Stats.new('team2', :team_id => id2)

    Stats.to_data_vault(stat1, stat2)
  end
end

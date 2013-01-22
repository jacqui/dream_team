namespace :stats do
  namespace :nyt do
    desc "scrape nytimes.stats.com for given team stats"
    task :teams => :environment do
      ids_csv = ENV['IDS']
      ids = ids_csv.split(",").map(&:strip)

      stats = ids.map do |id|
        puts "Scraping data for team id#: #{id}"
        Stats.new(:team_id => id)
      end

      puts "Generating datavault-friendly tab-delimited version of the stats..."
      Stats.to_data_vault(stats)
      puts "Done!"
    end
  end
end

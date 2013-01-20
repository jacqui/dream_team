namespace :tag do
  desc "Lookup players in the TimesTags API"
  task :players => :environment do

    PlayerTopics.new.lookup
  end
end

require 'yaml'
require 'times_topics'
class PlayerTopics

  def lookup
    players = Team.find_by_slug('sea').players
    puts "Players on the #{team.name_and_location}:"
    players.each do |player|
      print "\t#{player.name}..."
      if tag = TimesTags.person_search(player.name)
        puts " found!"
        require 'debugger'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
        puts tag
      else
        puts " miss."
      end
    end
  end
end

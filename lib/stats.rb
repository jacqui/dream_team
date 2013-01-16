require 'open-uri'
require 'nokogiri'
require 'yaml'
class Stats

  attr_accessor :config, :api_key, :base_url

  def initialize
    @base_url = "http://nytimes.stats.com/fb/"
  end

  def get_roster_for_team(team_name, opts = {})
    file_path = File.join(Rails.root, "db", "data", "#{team_name}.html")
    if File.exists?(file_path)
      open(file_path).read
    elsif opts[:team_id]
      url = "http://nytimes.stats.com/fb/teamstats.asp?tm=19&type=rosters"
      page = open(url).read
      open(file_path, 'w') { |f| f.write page }
      page
    else
      raise "You must pass a :team_id to .parse_roster to download a new roster page! (http://nytimes.stats.com/fb/teams.asp)"
    end
  end

  def get_stats_for_player(url)
    file_path = File.join(Rails.root, "db", "data", "url", "#{url.parameterize}")
    if File.exists?(file_path)
      open(file_path).read
    else
      page = open(url).read
      FileUtils.mkdir_p(File.join(Rails.root, "db", "data", "url"))
      open(file_path, 'w') { |f| f.write page }
      page
    end
  end

  def parse_roster(team_name, opts = {})
    doc = Nokogiri::HTML get_roster_for_team(team_name, opts)

    rows = doc.at("table.shsTable.shsBorderTable").search("tr")

    player_rows = rows[1,rows.size]

    players_data = player_rows.map do |player_row|
      player_cells = player_row.search("td")

      data = {
        "team" => team_name.titleize,
        "number" => player_cells[0].inner_text,
        "name" => player_cells[1].inner_text,
        "position" => player_cells[2].inner_text,
        "college" => player_cells[8].inner_text
      }

      next unless %w(QB RB TE WR K CB LB DE DT S).include?(data['position'])
      stats_url = [@base_url, player_cells[1].at('a')['href']].join
      stats_doc = Nokogiri::HTML get_stats_for_player(stats_url)
      # stats_doc = Nokogiri::HTML open(stats_url)

      box_stats_table = stats_doc.at("table#shsPlayerStatBox")
      box_stats = nil

      if box_stats_table
        box_stats = box_stats_table.search("tr")[1].search("td")
      else
        require 'debugger'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger
        puts box_stats_table
      end

      current_stats_row = if stats_table = stats_doc.at("h2.shsTableTitle ~ table")
                            stats_table.search("tr").detect{|tr| tr.search("td").first.inner_text == "2012" }
                          end

      if current_stats_row.blank?
        puts stats_url
        puts " - no stats found for 2012"
        next
      end

      current_stats = current_stats_row.search("td")
      data['G'] = current_stats[2].inner_text
      data['TDS'] = box_stats[2].inner_text

      %w(PCT Int Car Yards FGM XPM Tackles Sacks FF).each{|stat| data[stat] = '' }

      case data['position']

      # Offense
      when 'QB'
        data['PCT'] = current_stats[5].inner_text
        data['Int'] = current_stats[9].inner_text

      when "RB"
        #* Car (carries)
        #* Fum (fumbles)
        data['Car'] = current_stats[0].inner_text
        data['Yards'] = box_stats[1].inner_text
        # our pages don't seem to have this info. guh.
        # data['Fum'] = current_stats[8].inner_text
      when "WR"
        #* Rec (receptions)
        #* Fum (fumbles)
        data['Rec'] = box_stats[0].inner_text
        data['Yards'] = box_stats[1].inner_text
        # our pages don't seem to have this info. guh.
        # data['Fum'] = current_stats[8].inner_text
      when "TE"
        #* Rec (receptions)
        #* Fum (fumbles)
        data['Rec'] = box_stats[0].inner_text
        data['Yards'] = box_stats[1].inner_text
        # our pages don't seem to have this info. guh.
        # data['Fum'] = current_stats[8].inner_text
      when "K"
        #* FGM (made)
        #* FGA (attempted)
        data['FGM'] = box_stats[0].inner_text
        data['XPM'] = box_stats[1].inner_text

      # Defense
      when /^CB|LB|DE|DT|S$/
        #* tackles
        #* sacks
        #* ff (forced fumbles) (opt)
        data['Tackles'] = box_stats[0].inner_text
        data['Sacks'] = box_stats[1].inner_text
        data['FF'] = current_stats[11].inner_text
      else
        puts "#{data['name']}: failed finding stats for position '#{data['position']}'"
      end
      data
    end

    player_data_path = File.join(Rails.root, 'db', 'data', "players_data_#{team_name}.json")
    keys = players_data.first.keys

    File.open("db/data/datavault.txt", "w") do |f|
      f.puts keys.join("\t")
      players_data.compact.each do |playah|
        row_values = keys.map do |key|
          playah[key].to_s.strip
        end
        f.puts row_values.join("\t")
      end
    end
    Oj.to_file(player_data_path, players_data)
    puts "Dumped player stats to #{player_data_path}"
  end
end

Stats.new.parse_roster('giants', :team_id => 19)

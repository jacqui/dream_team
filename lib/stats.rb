require 'open-uri'
require 'nokogiri'
require 'yaml'
class Stats

  attr_accessor :team_id, :base_url, :data_root, :team_name

  def initialize(opts = {})
    @team_id = opts[:team_id]
    @base_url = opts[:base_url] || "http://nytimes.stats.com/fb/"
    @data_root = File.join(Rails.root, "db", "data", "nytimes_stats_com")
  end

  def data_root=(path)
    @data_root = path
  end

  def players_data
    return @players_data if @players_data.present?
    @players_data = _parse_roster
  end

  def self.to_data_vault(*stats)
    stats.flatten!
    data_root = stats.first.data_root
    stats.first.send(:_create_data_root)

    dv_path = File.join(data_root, "data_vault_#{stats.map(&:team_id).join('_v_')}.txt")
    File.open(dv_path, "w") do |f|
      keys = stats.first.players_data.first.keys
      f.puts keys.join("\t")

      stats.each do |stat|

        player_data_path = File.join(data_root, "players_data_#{stat.team_id}.json")
        stat.players_data.compact.each do |playah|
          row_values = keys.map do |key|
            playah[key].to_s.strip
          end
          f.puts row_values.join("\t")
        end

        Oj.to_file(player_data_path, stat.players_data)
        puts "Dumped player stats to #{player_data_path}"

      end
    end
    puts "Dumped stats for data vault to: #{dv_path}"
  end

  private

  def get_roster_for_team(opts = {})
    file_path = File.join(data_root, "roster_#{team_id}.html")
    if File.exists?(file_path)
      open(file_path).read
    elsif team_id
      url = "http://nytimes.stats.com/fb/teamstats.asp?tm=#{team_id}&type=rosters"
      page = open(url).read
      open(file_path, 'w') { |f| f.write page }
      page
    else
      raise "You must pass a :team_id to .parse_roster to download a new roster page! (http://nytimes.stats.com/fb/teams.asp)"
    end
  end

  def get_stats_for_player(url)
    file_path = File.join(data_root, "url", "#{url.parameterize}")
    if File.exists?(file_path)
      open(file_path).read
    else
      page = open(url).read
      FileUtils.mkdir_p(File.join(data_root, "url"))
      open(file_path, 'w') { |f| f.write page }
      page
    end
  end

  def _create_data_root
    # ensure the directory exists before setting this value
    if !File.exists?(data_root)
      FileUtils.mkdir_p(data_root)
    end
  end

  def _parse_roster(opts = {})
    doc = Nokogiri::HTML get_roster_for_team(opts)

    @team_name = doc.at("span.shsTeamName").inner_text

    rows = doc.at("table.shsTable.shsBorderTable").search("tr")

    player_rows = rows[1,rows.size]

    roster = player_rows.map do |player_row|
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

    roster
  end

end


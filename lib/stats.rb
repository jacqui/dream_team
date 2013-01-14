require 'open-uri'
require 'nokogiri'
require 'yaml'
class Stats

  attr_accessor :config, :api_key, :base_url

  def initialize
    @base_url = "http://nytimes.stats.com/fb/"
  end

### RB
* Car (carries)
* Fum (fumbles)

### WR
* Rec (receptions)
* Fum (fumbles)

### TE
* Rec (receptions)
* Fum (fumbles)

### K
* FGM (made)
* FGA (attempted)

### DEF
* tackles
* sacks
* ff (forced fumbles) (opt)
* CB/LB/DE/DT/S

  
  def stats_for(position)
    {
      'QB' => ['G', 'Comp %', 'Int', 'Rating'],
      'RB' => ['G', 'Carries', 'Int', 'Rating'],
      'WR' => ['G', 'Comp %', 'Int', 'Rating'],
      'TE' => ['G', 'Comp %', 'Int', 'Rating'],
      'K' => ['G', 'Comp %', 'Int', 'Rating'],
      'CB' => ['G', 'Comp %', 'Int', 'Rating'],
    }[position]
  end

  def parse_roster(team_name)
    # url = URI.join(base_url, path)
    full_path = File.join(Rails.root, "db", "data", "#{team_name}.html")
    doc = Nokogiri::HTML open(full_path)
    rows = doc.at("table.shsTable.shsBorderTable").search("tr")
    player_rows = rows[1,rows.size]
    players_data = player_rows.map do |player_row|
      player_cells = player_row.search("td")
      data = [
        "team" => team_name.titleize,
        "number" => player_cells[0].inner_text,
        "name" => player_cells[1].inner_text,
        "position" => player_cells[2].inner_text,
        "college" => player_cells[8].inner_text
      ]

      stats_url = [@base_url, player_cells[1].at('a')['href']].join
      stats_doc = Nokogiri::HTML open(stats_url)

      box_stats = doc.at("table#shsPlayerStatBox").search("tr")

      case data['position']
      when 'QB'
        key_stats = doc.at("table.shsTable.shsBorderTable").search("tr")[1].search("td")
        data['G'] = key_stats[2].inner_text
        data['PCT'] = key_stats[5].inner_text
        data['TDS'] = key_stats[8].inner_text
        data['Int'] = key_stats[9].inner_text

      when "RB"
      when "WR"
      when "TE"
      when "K"
      when /^CB|LB|DE|DT|S$/
      else
        puts "#{data['name']}: failed finding stats for position '#{data['position']}'"
      end
    end
    Oj.dump(players_data)
  end
end

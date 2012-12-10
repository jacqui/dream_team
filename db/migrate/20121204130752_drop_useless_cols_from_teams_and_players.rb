class DropUselessColsFromTeamsAndPlayers < ActiveRecord::Migration
  def up
    remove_column :teams, :web_link
    remove_column :teams, :api_link
    remove_column :teams, :news_api_link
    remove_column :teams, :notes_api_link
    remove_column :teams, :mobile_link
    remove_column :teams, :espn_id

    add_column :teams, :source, :string
    add_column :teams, :source_id, :integer

    remove_column :players, :espn_id
    remove_column :players, :short_name
    remove_column :players, :first_name
    remove_column :players, :last_name
    remove_column :players, :display_name
  end

  def down
  end
end

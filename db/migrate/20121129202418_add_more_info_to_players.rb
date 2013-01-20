class AddMoreInfoToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :full_name, :string
    add_column :players, :display_name, :string
    add_column :players, :short_name, :string
    add_column :players, :espn_id, :string
    add_column :teams, :espn_id, :string
  end
end

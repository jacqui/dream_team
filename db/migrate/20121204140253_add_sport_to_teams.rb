class AddSportToTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :sport_id
    add_column :teams, :sport, :string
  end
end

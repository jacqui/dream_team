class UpdateTeamsTableWithForeignKeys < ActiveRecord::Migration
  def up
    remove_column :teams, :sport
    remove_column :teams, :conference
    remove_column :teams, :division
    remove_column :teams, :league

    add_column :teams, :sport_id, :integer
    add_column :teams, :conference_id, :integer
    add_column :teams, :division_id, :integer
    add_column :teams, :league_id, :integer
  end

  def down
    remove_column :teams, :league_id
    remove_column :teams, :division_id
    remove_column :teams, :conference_id
    remove_column :teams, :sport_id

    add_column :teams, :league, :string
    add_column :teams, :division, :string
    add_column :teams, :conference, :string
    add_column :teams, :sport, :string
  end
end

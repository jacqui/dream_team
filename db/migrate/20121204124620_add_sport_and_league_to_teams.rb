class AddSportAndLeagueToTeams < ActiveRecord::Migration
  def up
    change_table :teams do |t|
      t.references :sport
      t.string :league
      t.index :sport_id
      t.index :league
      t.index :name
      t.index :location
      t.index :abbreviation
    end
  end

  def down
    change_table :teams do |t|
      t.remove_references :sport
      t.remove :league
      t.remove_index :league
      t.remove_index :name
      t.remove_index :location
      t.remove_index :abbreviation
    end
  end
end

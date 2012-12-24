class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :abbreviation
      t.string :slug
      t.references :sport

      t.timestamps
    end
  end
end

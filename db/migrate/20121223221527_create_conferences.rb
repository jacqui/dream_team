class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :abbreviation
      t.string :slug
      t.references :league

      t.timestamps
    end
  end
end

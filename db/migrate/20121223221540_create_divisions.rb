class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name
      t.string :abbreviation
      t.string :slug
      t.references :conference

      t.timestamps
    end
  end
end

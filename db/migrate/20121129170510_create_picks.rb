class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :reader_id
      t.integer :pick_id
      t.string :pick_type
      t.string :date_window

      t.timestamps
    end
  end
end

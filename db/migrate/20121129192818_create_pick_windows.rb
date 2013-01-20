class CreatePickWindows < ActiveRecord::Migration
  def up
    create_table :pick_windows do |t|
      t.datetime :window_start
      t.datetime :window_end
      t.integer  :project_id

      t.timestamps
    end

    add_column :picks, :pick_window_id, :integer
    remove_column :picks, :date_window
  end

  def down
    add_column :picks, :date_window, :string
    remove_column :picks, :pick_window_id
    drop_table :pick_window
  end
end

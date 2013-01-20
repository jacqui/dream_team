class CreatePickBuckets < ActiveRecord::Migration
  def change
    create_table :pick_buckets do |t|
      t.string  :pick_type,      :null => false
      t.integer :pick_window_id, :null => false
      t.integer :count,          :null => false
      t.boolean :required,       :null => false, :default => true

      t.timestamps
    end

    add_column :picks, :pick_bucket_id, :integer
  end
end

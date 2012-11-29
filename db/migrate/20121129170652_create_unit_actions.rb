class CreateUnitActions < ActiveRecord::Migration
  def change
    create_table :unit_actions do |t|
      t.integer :points
      t.string :qualifying_metric_type
      t.integer :qualifying_metric_amount
      t.string :qualifying_position

      t.timestamps
    end
  end
end

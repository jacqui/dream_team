class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end

    add_column :picks, :project_id, :integer
  end
end

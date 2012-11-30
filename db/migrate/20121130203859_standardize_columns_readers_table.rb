class StandardizeColumnsReadersTable < ActiveRecord::Migration
  def up
    remove_column :readers, :nyt_id 
    remove_column :readers, :nyt_username 
    remove_column :readers, :first_name 
    remove_column :readers, :last_name 

    add_column :readers, :nytimes_id, :integer
    add_column :readers, :name, :string
    add_column :readers, :username, :string

    add_index :readers, :nytimes_id
  end

  def down
  end
end

class CreateReaders < ActiveRecord::Migration
  def change
    create_table :readers do |t|
      t.string :first_name
      t.string :last_name
      t.string :nyt_id
      t.string :nyt_username

      t.timestamps
    end
  end
end

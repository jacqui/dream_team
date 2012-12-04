class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string :name
      t.text :description
      t.string :nyt_blog_url
      t.string :image_url

      t.timestamps
    end
  end
end

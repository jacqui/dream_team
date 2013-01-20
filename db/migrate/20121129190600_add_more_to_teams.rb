class AddMoreToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :location, :string
    add_column :teams, :color, :string
    add_column :teams, :abbreviation, :string
    add_column :teams, :web_link, :string
    add_column :teams, :api_link, :string
    add_column :teams, :news_api_link, :string
    add_column :teams, :mobile_link, :string
    add_column :teams, :notes_api_link, :string
  end
end

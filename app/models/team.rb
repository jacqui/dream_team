class Team < ActiveRecord::Base
  attr_accessible :name, :color, :web_link, :api_link, :news_api_link, :notes_api_link, :mobile_link, :espn_id
  has_many :players
end

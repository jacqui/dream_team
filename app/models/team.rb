class Team < ActiveRecord::Base
  has_many :players

  attr_accessible :name, :abbreviation, :location, :color, :web_link, :api_link, :news_api_link, :notes_api_link, :mobile_link, :espn_id

  validates_presence_of :name, :abbreviation, :location

  def name_and_location
    [location, name].join(" ")
  end

  def to_param
    abbreviation.downcase
  end
end

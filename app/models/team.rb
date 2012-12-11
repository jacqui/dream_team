class Team < ActiveRecord::Base
  has_many :players, :order => "position, full_name"

  attr_accessible :name, :abbreviation, :location, :sport, :league, :conference, :division, :color, :source, :source_id

  validates_presence_of :name, :abbreviation, :location, :sport, :league

  def name_and_location
    [location, name].join(" ")
  end

  def to_param
    abbreviation.downcase
  end

end

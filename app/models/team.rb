class Team < ActiveRecord::Base
  has_many :players, :order => "position, full_name"
  belongs_to :sport
  belongs_to :league
  belongs_to :conference
  belongs_to :division

  attr_accessible :name, :abbreviation, :location, :sport_id, :league_id, :conference_id, :division_id, :color, :source, :source_id
  validates_presence_of :name, :abbreviation, :location, :sport, :league

  def name_and_location
    [location, name].join(" ")
  end

  def to_param
    abbreviation.downcase
  end

end

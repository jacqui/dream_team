class Conference < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :league_id
  has_many :divisions
  has_many :teams
  belongs_to :league

  validates_presence_of :abbreviation, :league

  include Sluggish
end

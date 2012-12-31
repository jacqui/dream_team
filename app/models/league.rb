class League < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :sport_id
  has_many :conferences
  has_many :teams
  belongs_to :sport

  validates_presence_of :abbreviation, :sport

  include Sluggish
end

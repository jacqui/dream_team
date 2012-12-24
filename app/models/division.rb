class Division < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :conference_id
  has_many :teams
  belongs_to :conference

  include Sluggish
end

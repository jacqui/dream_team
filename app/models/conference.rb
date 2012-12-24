class Conference < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :league_id
  has_many :divisions
  belongs_to :league

  include Sluggish
end

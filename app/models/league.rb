class League < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :sport_id
  has_many :conferences
  belongs_to :sport

  include Sluggish
end

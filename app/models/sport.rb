class Sport < ActiveRecord::Base
  attr_accessible :name, :slug
  has_many :leagues

  include Sluggish
end

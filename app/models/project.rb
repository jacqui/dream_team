class Project < ActiveRecord::Base
  has_many :pick_windows
  attr_accessible :name, :slug
end

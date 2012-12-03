class Player < ActiveRecord::Base
  belongs_to :team

  attr_accessible :bio, :first_name, :last_name, :position, :team, :full_name, :source_id, :source

  validates_presence_of :full_name
end

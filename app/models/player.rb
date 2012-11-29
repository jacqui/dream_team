class Player < ActiveRecord::Base
  attr_accessible :bio, :first_name, :last_name, :position
  belongs_to :team
end

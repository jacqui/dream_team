class Player < ActiveRecord::Base
  attr_accessible :bio, :first_name, :last_name, :position
end

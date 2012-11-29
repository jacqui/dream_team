class Player < ActiveRecord::Base
  attr_accessible :bio, :first_name, :last_name, :position
  belongs_to :team

  def full_name
    "#{first_name} #{last_name}"
  end
end

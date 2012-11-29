class Reader < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :nyt_id, :nyt_username
end

class Pick < ActiveRecord::Base
  belongs_to :project
  attr_accessible :date_window, :pick_id, :pick_type, :reader_id
end

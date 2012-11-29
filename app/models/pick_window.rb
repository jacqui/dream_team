class PickWindow < ActiveRecord::Base
  attr_accessible :project_id, :window_end, :window_start
end

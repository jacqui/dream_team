class PickWindow < ActiveRecord::Base
  belongs_to :project

  attr_accessible :project_id, :window_end, :window_start

  default_scope :order => "window_start ASC"

  # What index is the position of this pick window within all windows for the
  # project?
  def index
    project.pick_windows.index(self) + 1
  end
end

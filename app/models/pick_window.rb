class PickWindow < ActiveRecord::Base
  belongs_to :project
  has_many :pick_buckets

  attr_accessible :project_id, :window_end, :window_start

  validates_uniqueness_of :project_id, :scope => [:window_end, :window_start]

  default_scope :order => "window_start ASC"

  # What index is the position of this pick window within all windows for the
  # project?
  def index
    project.pick_windows.index(self) + 1
  end
end

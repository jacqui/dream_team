class Pick < ActiveRecord::Base
  belongs_to :project
  belongs_to :reader
  belongs_to :pick_window
  attr_accessible :date_window, :pick_id, :pick_type, :project_id, :reader_id, :pick_window_id, :pick_bucket_id
  validates_uniqueness_of :pick_id, :scope => [:pick_type, :project_id, :reader_id, :pick_window_id, :pick_bucket_id]
end

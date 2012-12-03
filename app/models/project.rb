class Project < ActiveRecord::Base
  has_many :pick_windows
  attr_accessible :name, :slug

  # If today is within a pick window, return it.
  # Otherwise, return nil.
  def current_pick_window
    pick_windows.where("window_start < '#{DateTime.now}' AND window_end > '#{DateTime.now}'").first
  end

  def to_param
    slug
  end
end

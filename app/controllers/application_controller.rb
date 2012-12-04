class ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthFilters
  before_filter :set_project, :set_reader

end

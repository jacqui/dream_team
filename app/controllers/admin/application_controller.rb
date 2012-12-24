class Admin::ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthFilters

  before_filter :set_sport

  def set_sport
    if params && params[:sport] && controller_name != 'sports'
      @sport = Sport.find_by_slug(params[:sport])
      self.default_url_options[:sport] = @sport.slug if @sport
    end
  end
end

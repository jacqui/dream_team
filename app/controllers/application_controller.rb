class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_project, :set_reader

  def set_project
    @project = Project.find_by_slug(params[:project])
    if @project.blank?
      @project = Project.first
    end
    self.default_url_options[:project] = @project.slug
  end

  # Hard code for now.
  # TODO: Make this transparent, possibly use code from chad / extract into
  # gem.
  def set_reader
    @reader = Reader.first
  end

end

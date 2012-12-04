class Admin::ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_project, :set_reader

  def set_project
    @project = Project.find_by_slug(params[:project])
    if @project.blank?
      @project = Project.first || Project.create!(
        :name => "Super Bowl 2013",
        :slug => "super-bowl-2013"
      )
    end
    self.default_url_options[:project] = @project
  end

  # Hard code for now.
  # TODO: Make this transparent, possibly use code from chad / extract into
  # gem.
  def set_reader
    @reader = Reader.first || Reader.create!(
      :name => "Michael Strickland",
      :username => "moriogawa",
      :nytimes_id => "47860851"
    )
  end

end

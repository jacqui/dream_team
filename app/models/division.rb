class Division < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :slug, :conference_id
  has_many :teams
  belongs_to :conference

  include Sluggish

  def generate_slug
    self.slug ||= [conference.slug, name.parameterize].join('-')
  end
end

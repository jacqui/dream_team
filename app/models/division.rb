class Division < ActiveRecord::Base
  has_many :teams
  belongs_to :conference

  attr_accessible :abbreviation, :name, :slug, :conference_id
  validates_presence_of :abbreviation, :conference

  include Sluggish

  def generate_slug
    self.slug ||= [conference.slug, name.parameterize].join('-')
  end
end

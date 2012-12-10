class Player < ActiveRecord::Base
  belongs_to :team

  attr_accessible :full_name, :position, :team, :source, :source_id, :slug, :bio

  validates_presence_of :full_name

  def to_param
    slug
  end

  before_save do
    self.slug = full_name.parameterize
  end

  def badge_color
    case position
    when 'QB'
      'badge-success'
    when 'RB'
      'badge-warning'
    when 'WR'
      'badge-important'
    when 'TE'
      'badge-info'
    when 'K'
      'badge-inverse'

    end
  end
end

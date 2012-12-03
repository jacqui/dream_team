class Player < ActiveRecord::Base
  belongs_to :team

  attr_accessible :bio, :first_name, :last_name, :position, :team, :full_name, :source_id, :source, :slug

  validates_presence_of :full_name

  def to_param
    slug
  end

  before_save do
    self.slug = full_name.parameterize
  end
end

module Sluggish

  extend ActiveSupport::Concern
  
  included do
    validates :name, uniqueness: true, presence: true
    validates :slug, uniqueness: true, presence: true
    before_validation :generate_slug
  end

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= name.parameterize
  end
end

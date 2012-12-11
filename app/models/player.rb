class Player < ActiveRecord::Base
  belongs_to :team

  attr_accessible :full_name, :position, :team, :source, :source_id, :slug, :bio

  validates_presence_of :full_name

  def to_json
    self.attributes.merge({
      # :badge_color => badge_color
    })
  end

  def to_param
    slug
  end

  before_save do
    self.slug = full_name.parameterize
  end

  NFL_POSITIONS = { 
    'QB' => { 'name' => 'Quarterback', 'badge' => 'success' },
    'RB' => { 'name' => 'Running Back', 'badge' => 'warning' },
    'WR' => { 'name' => 'Wide Receiver', 'badge' => 'important' },
    'TE' => { 'name' => 'Tight End', 'badge' => 'info' },
    'K' => { 'name' => 'K', 'badge' => 'inverse' }
  }

  def badge_color
    if NFL_POSITIONS.key?(position)
      ['badge', NFL_POSITIONS[position]['badge']].join('-')
    else
      'badge'
    end
  end

  def position_name
    if NFL_POSITIONS.key?(position)
      NFL_POSITIONS[position]['name']
    else
      position
    end
  end
end

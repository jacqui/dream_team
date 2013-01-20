class PickBucket < ActiveRecord::Base
  attr_accessible :count, :pick_type, :pick_window_id, :required

  validates_presence_of :required, :pick_type, :pick_window_id, :count
  validates :count, :numericality => {:greater_than => 0}

  alias :old_to_json :to_json

  def to_json
    attributes.merge({
      :player_ids => player_ids
    })
  end

  def player_ids
    # TODO: Don't hardcode!
    @reader = Reader.first
    @project = Project.first

    []
    Pick.where(
      :reader_id => @reader.id,
      :pick_type => pick_type,
      :project_id => @project.id,
      :pick_window_id => pick_window_id
    ).map(&:pick_id)
  end

end

class PicksController < ApplicationController

  before_filter :set_pick_window

  def new
    @candidates = Player.all[0..20]

    # TODO: Filter to only those players that will be competing this period.
    # @candidates = @candidates.in_window(@pick_window)

    # TODO: Filter out players this reader has already picked.
    @pick_buckets = @pick_window.pick_buckets

    # Find existing picks by this user. Then, loop over all possible pick
    # profiles for this pick window, inserting existing picks where possible,
    # otherwise creating blank ones.

    existing_picks = Pick.where(
      :reader_id  => @reader.id,
      :pick_window_id => @pick_window.id
    )

    @picks = @pick_buckets.map do |bucket|
      usable_picks = existing_picks.select { |pick| pick.pick_type == bucket.pick_type }
      new_picks = (bucket.count - usable_picks.size).times.map do
        Pick.new(
          :project_id => @project.id,
          :reader_id => @reader.id,
          :pick_window_id => @pick_window.id
        )
      end

      [usable_picks, new_picks].compact.flatten
    end
    @picks.flatten!
  end

  def update
    params[:buckets].each do |idx, b|
      bucket = PickBucket.find(b["id"])
      b["player_ids"] ||= []

      # Find the existing picks
      existing = Pick.where(
        :pick_type => b["pick_type"],
        :project_id => @project.id,
        :pick_window_id => @pick_window.id,
        :pick_bucket_id => bucket.id,
        :reader_id => @reader.id
      )

      # Delete any not in the new set
      existing.reject { |pick| b["player_ids"].include?(pick.id) }.map(&:destroy)

      # Add any new players
      pp b
      to_create = b["player_ids"] - existing.map(&:id).map(&:to_s)
      to_create.each do |player_id|
        Pick.create(
          :pick_id => player_id,
          :pick_type => b["pick_type"],
          :project_id => @project.id,
          :pick_window_id => @pick_window.id,
          :pick_bucket_id => bucket.id,
          :reader_id => @reader.id
        )
      end
    end

    render :json => {}
  end

  private

  def set_pick_window
    @pick_window = @project.current_pick_window
  end

end

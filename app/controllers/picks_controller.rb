class PicksController < ApplicationController

  before_filter :set_pick_window

  def new
    @candidates = Player.all[0..20]

    # TODO: Filter to only those players that will be competing this period.
    # @candidates = @candidates.in_window(@pick_window)

    # TODO: Filter out players this reader has already picked.

    @pick = Pick.new
  end

  private

  def set_pick_window
    @pick_window = @project.current_pick_window
  end

end

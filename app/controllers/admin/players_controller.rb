class Admin::PlayersController < Admin::ApplicationController
  before_filter :find_player, :except => [:index, :new, :create]
  # GET /admin/players
  # GET /admin/players.json
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  # GET /admin/players/1
  # GET /admin/players/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
    end
  end

  # GET /admin/players/new
  # GET /admin/players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player }
    end
  end

  # GET /admin/players/1/edit
  def edit
  end

  # POST /admin/players
  # POST /admin/players.json
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/players/1
  # PUT /admin/players/1.json
  def update
    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/players/1
  # DELETE /admin/players/1.json
  def destroy
    @player.destroy

    respond_to do |format|
      format.html { redirect_to admin_players_url }
      format.json { head :no_content }
    end
  end
private

  def find_player
    @player = Player.find_by_slug(params[:id])
    @team = @player.team
  end
end

class Admin::TeamsController < Admin::ApplicationController
  before_filter :find_team, :except => [:index, :new, :create]
  # GET /admin/teams
  # GET /admin/teams.json
  def index
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /admin/teams/1
  # GET /admin/teams/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /admin/teams/new
  # GET /admin/teams/new.json
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /admin/teams/1/edit
  def edit
  end

  # POST /admin/teams
  # POST /admin/teams.json
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/teams/1
  # PUT /admin/teams/1.json
  def update
    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/teams/1
  # DELETE /admin/teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to admin_teams_url }
      format.json { head :no_content }
    end
  end

private

  def find_team
    @team = Team.find_by_abbreviation(params[:id].downcase)
  end
end

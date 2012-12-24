class Admin::ConferencesController < Admin::ApplicationController

  before_filter :find_league_and_conference
#  before_filter :find_conference, :except => [:index, :new, :create]

  # GET /admin/conferences
  # GET /admin/conferences.json
  def index
    @conferences = @league.conferences

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }
    end
  end

  # GET /admin/conferences/1
  # GET /admin/conferences/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /admin/conferences/new
  # GET /admin/conferences/new.json
  def new
    @conference = @league.conferences.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /admin/conferences/1/edit
  def edit
  end

  # POST /admin/conferences
  # POST /admin/conferences.json
  def create
    @conference = @league.conferences.build(params[:conference])

    respond_to do |format|
      if @conference.save
        format.html { redirect_to [:admin, @sport], notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/conferences/1
  # PUT /admin/conferences/1.json
  def update
    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to [:admin, @sport], notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/conferences/1
  # DELETE /admin/conferences/1.json
  def destroy
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, @sport] }
      format.json { head :no_content }
    end
  end

private

  def find_league_and_conference
    if params[:id]
      @conference = Conference.find_by_slug(params[:id])
      @league = @conference.league
    elsif params[:conference] && params[:conference][:league_id]
      @league = @sport.leagues.find_by_id(params[:conference][:league_id])
    else
      @league = @sport.leagues.find_by_slug(params[:league])
    end
  end

end

class Admin::SportsController < Admin::ApplicationController

  before_filter :find_sport, :except => [:index, :new, :create]
  # GET /admin/sports
  # GET /admin/sports.json
  def index
    @sports = Sport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sports }
    end
  end

  # GET /admin/sports/1
  # GET /admin/sports/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sport }
    end
  end

  # GET /admin/sports/new
  # GET /admin/sports/new.json
  def new
    @sport = Sport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sport }
    end
  end

  # GET /admin/sports/1/edit
  def edit
  end

  # POST /admin/sports
  # POST /admin/sports.json
  def create
    @sport = Sport.new(params[:sport])

    respond_to do |format|
      if @sport.save
        format.html { redirect_to [:admin, @sport], notice: 'Sport was successfully created.' }
        format.json { render json: @sport, status: :created, location: @sport }
      else
        format.html { render action: "new" }
        format.json { render json: @sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sports/1
  # PUT /admin/sports/1.json
  def update
    respond_to do |format|
      if @sport.update_attributes(params[:sport])
        format.html { redirect_to [:admin, @sport], notice: 'Sport was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sports/1
  # DELETE /admin/sports/1.json
  def destroy
    @sport.destroy

    respond_to do |format|
      format.html { redirect_to admin_sports_url }
      format.json { head :no_content }
    end
  end

private

  def find_sport
    @sport = Sport.find_by_slug(params[:id])
  end
end

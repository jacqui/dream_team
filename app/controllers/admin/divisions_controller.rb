class Admin::DivisionsController < Admin::ApplicationController

  before_filter :find_conference_and_division

  # GET /admin/divisions
  # GET /admin/divisions.json
  def index
    @divisions = @conference.divisions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @divisions }
    end
  end

  # GET /admin/divisions/1
  # GET /admin/divisions/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @division }
    end
  end

  # GET /admin/divisions/new
  # GET /admin/divisions/new.json
  def new
    @division = @conference.divisions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @division }
    end
  end

  # GET /admin/divisions/1/edit
  def edit
  end

  # POST /admin/divisions
  # POST /admin/divisions.json
  def create
    @division = @conference.divisions.build(params[:division])

    respond_to do |format|
      if @division.save
        format.html { redirect_to [:admin, @sport], notice: 'Conference was successfully created.' }
        format.json { render json: @division, status: :created, location: @division }
      else
        format.html { render action: "new" }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/divisions/1
  # PUT /admin/divisions/1.json
  def update
    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { redirect_to [:admin, @sport], notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/divisions/1
  # DELETE /admin/divisions/1.json
  def destroy
    @division.destroy

    respond_to do |format|
      format.html { redirect_to [:admin, @sport] }
      format.json { head :no_content }
    end
  end

private

  def find_conference_and_division
    if params[:id]
      @division = Division.find_by_slug(params[:id])
      @conference = @division.conference
    elsif params[:division] && params[:division][:conference_id]
      @conference = Conference.find_by_id(params[:division][:conference_id])
    else
      @conference = Conference.find_by_slug(params[:conference])
    end
  end

end

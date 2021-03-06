class CyclistsController < ApplicationController
  before_action :set_cyclist, only: [:show, :edit, :update, :destroy]

  # GET /cyclists
  # GET /cyclists.json
  def index
    @cyclists = Cyclist.all    
=begin
    @client = Strava::Api::V3::Client.new(:access_token => "f4d2110fa049267d3d49a4e2fea2d8b51329fb6c")
    result = @client.list_athlete_activities
    open('list_athlete_activities_donald.json', 'w') do |f|
      f.puts result
    end
=end
=begin
    auth_param = 'Bearer ' + 'b9405ea739177180f34b207826b64e801a024ca6'
    result = RestClient.get "https://www.strava.com/api/v3/activities/565825056?include_all_efforts=true", :Authorization => auth_param
    open('tyler_activity_565825056.json', 'w') do |f|
      f.puts result
    end   
=end
  end

  # GET /cyclists/1
  # GET /cyclists/1.json
  def show    
    
  end

  # GET /cyclists/new
  def new
    @cyclists = Cyclist.all
    @cyclist = Cyclist.new
  end

  # GET /cyclists/1/edit
  def edit
    @cyclists = Cyclist.all
  end

  # POST /cyclists
  # POST /cyclists.json
  def create
    @cyclist = Cyclist.new(cyclist_params)

    respond_to do |format|
      if @cyclist.valid? and @cyclist.save
        format.html { redirect_to cyclists_path, notice: 'Cyclist was successfully created.' }
        format.json { render :show, status: :created, location: @cyclist }
      else
        format.html { render :new }
        format.json { render json: @cyclist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cyclists/1
  # PATCH/PUT /cyclists/1.json
  def update
    respond_to do |format|
      if @cyclist.update(cyclist_params)
        format.html { redirect_to cyclists_path, notice: 'Cyclist was successfully updated.' }
        format.json { render :show, status: :ok, location: @cyclist }
      else
        format.html { render :edit }
        format.json { render json: @cyclist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cyclists/1
  # DELETE /cyclists/1.json
  def destroy
    @cyclist.destroy
    respond_to do |format|
      format.html { redirect_to cyclists_path, notice: 'Cyclist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cyclist
      @cyclist = Cyclist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cyclist_params
      params.require(:cyclist).permit(:strava_athlete_url)
    end
end

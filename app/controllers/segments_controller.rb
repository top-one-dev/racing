class SegmentsController < ApplicationController
  before_action :set_segment

  # GET /segments
  # GET /segments.json
  def index
    @segments = @stage.all
  end

  # GET /segments/1
  # GET /segments/1.json
  def show
  end

  # GET /segments/new
  def new
    @segment = Segment.new
  end

  # GET /segments/1/edit
  def edit
  end

  # POST /segments
  # POST /segments.json
  def create
    @segment = @stage.segments.build(segment_params)

    respond_to do |format|
      if @segment.save
        format.html { redirect_to race_stage_path(@race, @stage), notice: 'Segment was successfully created.' }
        format.json { render :show, status: :created, location: @segment }
      else
        format.html { render :new }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /segments/1
  # PATCH/PUT /segments/1.json
  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to race_stage_path(@race, @stage), notice: 'Segment was successfully updated.' }
        format.json { render :show, status: :ok, location: @segment }
      else
        format.html { render :edit }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /segments/1
  # DELETE /segments/1.json
  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to race_stage_path(@race, @stage), notice: 'Segment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_segment

      @race = Race.find(params[:race_id])
      @stage = @race.stages.find(params[:stage_id]) unless @race.nil?

      if params[:id].present?
        @segment = @stage.segments.find(params[:id]) unless @stage.nil?
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def segment_params
      params.require(:segment).permit(:strava_segment_url)
    end
end

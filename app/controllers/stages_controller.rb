class StagesController < ApplicationController
  before_action :set_stage

  # GET /stages
  # GET /stages.json
  def index
    @stages = @race.stages
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
  end

  # GET /stages/new
  def new
    @stage = Stage.new
  end

  # GET /stages/1/edit
  def edit
  end

  # POST /stages
  # POST /stages.json
  def create
    @stage = @race.stages.build(stage_params)
    respond_to do |format|
      if @stage.save
        format.html { redirect_to race_path(@race), notice: 'Stage was successfully created.' }
        format.json { render :show, status: :created, location: @stage }
      else
        format.html { render :new }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stages/1
  # PATCH/PUT /stages/1.json
  def update
    respond_to do |format|
      if @stage.update(stage_params)
        format.html { redirect_to race_path(@race), notice: 'Stage was successfully updated.' }
        format.json { render :show, status: :ok, location: @stage }
      else
        format.html { render :edit }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    @stage.destroy
    respond_to do |format|
      format.html { redirect_to race_path(@race), notice: 'Stage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage      
      @race = Race.find(params[:race_id])
      if params[:id].present?
        @stage = @race.stages.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stage_params
      params.require(:stage).permit(:race_id, :name, :description, :active_date, :close_date)
    end
end

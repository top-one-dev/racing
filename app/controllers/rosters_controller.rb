class RostersController < ApplicationController
  before_action :set_roster

  # GET /rosters
  # GET /rosters.json
  def index
    @rosters = @race.rosters      
  end

  # POST /rosters
  # POST /rosters.json
  def create
    @roster = Roster.new(roster_params)
    respond_to do |format|
      if @roster.save
        format.html { redirect_to race_rosters_path(@race), notice: 'Roster was successfully created.' }
        format.json { render :show, status: :created, location: @roster }
      else
        format.html { render :new, notice: 'Roster could not be created.'  }
        format.json { render json: @roster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rosters/1
  # DELETE /rosters/1.json
  def destroy
    @roster.destroy
    respond_to do |format|
      format.html { redirect_to race_rosters_path(@race), notice: 'Roster was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roster      
      @race = Race.find(params[:race_id])
      if params[:id].present?
        @roster = @race.rosters.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roster_params
      params.require(:roster).permit(:race_id, :cyclist_id)
    end
end

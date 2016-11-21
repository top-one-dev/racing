class RostersController < ApplicationController
  before_action :set_roster

  # GET /rosters
  # GET /rosters.json
  def index
    @rosters = @race.rosters.order('cyclist.name DESC').reverse_order!    
  end

  # POST /rosters
  # POST /rosters.json
  def create
    @roster = Roster.new(roster_params)
    respond_to do |format|
      if @roster.save
        puts 'success to save'
        format.html { redirect_to race_rosters_path(@race), notice: 'Roster was successfully created.' }
        format.json { render :show, status: :created, location: @roster }
        format.js { render :js => "window.location = '#{race_result_path(race_id: @race)}';", notice: 'You was successfully joined.'}        
        # format.js { redirect_to race_result_path(@race), notice: 'You was successfully joined.'}        
      else
        puts "fail to save #{@roster.errors}"
        format.html { render :new, notice: 'Roster could not be created.'  }
        format.json { render json: @roster.errors, status: :unprocessable_entity }
        format.js { render :js => "window.location = '#{root_path}';", notice: 'Sorry, Something wrong! Try again.'}        
      end
    end
  end

  # DELETE /rosters/1
  # DELETE /rosters/1.json
  def destroy
    puts 'success to delete' if @roster.destroy
    respond_to do |format|
      format.html { redirect_to race_rosters_path(@race), notice: 'Roster was successfully removed.' }
      format.json { head :no_content }
      format.js { render :js => "window.location = '#{root_path}';", notice: 'You was successfully left.'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roster      
      @race = Race.find(params[:race_id]) if params[:race_id].present?
      @race = Race.find(params[:roster][:race_id]) unless params[:race_id].present?
      # puts "#{@race.name} - #{params[:race_id]} - #{params[:id]}"
      if params[:id].present?
        @roster = @race.rosters.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roster_params
      params.require(:roster).permit(:race_id, :cyclist_id)
    end
end

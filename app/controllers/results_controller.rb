class ResultsController < ApplicationController
  def index
  	@races = Race.all
  end

  def manage
  	@race = Race.find(params[:id])
    #@cyclists = sort_cyclists_race(@race)
    #@sorted_cyclists_race = sort_cyclists_race(@race)
    @sorted_cyclists_race_stage = sort_cyclists_race_stage_list(@race)
  end

  def stage_results
  	@race = Race.find(params[:race_id])
  	@stage = @race.stages.find(params[:id])
  	@cyclists = @race.cyclists    
    @cyclists = sort_cyclists_stage(@cyclists, @stage)    
  end

  def edit
    @race = Race.find(params[:race_id])
    @stage = @race.stages.find(params[:stage_id])
    @cyclist = Cyclist.find(params[:id])
  end    

  def update
    @race = Race.find(params[:race_id])
    @stage = @race.stages.find(params[:stage_id])
    @cyclist = Cyclist.find(params[:id])
    @stage_effect = StageEffect.new
  end
end

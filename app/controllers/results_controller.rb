class ResultsController < ApplicationController
  def index
  	@races = Race.all
  end

  def manage
  	@race = Race.find(params[:id])
  end

  def stage_results
  	@race = Race.find(params[:race_id])
  	@stage = @race.stages.find(params[:id])
  	@cyclists = @race.cyclists    

    #Ordering Cyclists by elapsed_time
    @sorted_cyclists = []
    @nil_cyclists = []

    @cyclists.each_with_index do |cyclist, index|
      stage_effort = cyclist.stage_efforts.find_by(stage_id: @stage)
      if stage_effort
        elapsed_time = stage_effort.elapsed_time if stage_effort.elapsed_time
        elapsed_time = nil if stage_effort.elapsed_time.nil?        
        @sorted_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => elapsed_time, 'point' =>5}
      else
        @nil_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => nil, 'point' => nil}
      end
    end
    @sorted_cyclists.sort_by!{|k| k['elapsed_time'].to_i}
    @nil_cyclists.each {|item| @sorted_cyclists << item}
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

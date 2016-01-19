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

=begin    
    @cyclists.each do |cyclist|
      stage_effort = cyclist.stage_efforts.find_by(stage_id: @stage)
        if stage_effort
          stage_effort.elapsed_time
        else
          
        end      
      end
    end

    #Ordering Cyclists by elapsed_time
    @sorted_cyclists = []
    @nil_cyclists = []

    @cyclists.each_with_index do |cyclist, index|
      stage_effort = cyclist.stage_efforts.find_by(stage_id: @stage)
      if stage_effort
        elapsed_time = stage_effort.elapsed_time # if stage_effort.elapsed_time
        if stage_effort.elapsed_time.to_i > 0
          @sorted_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => elapsed_time, 'point' =>5}
        else
          @sorted_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => 0, 'point' => nil}
        end
      else
        @nil_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => nil, 'point' => nil}
      end
    end
    @sorted_cyclists.sort_by!{|k| k['elapsed_time'].to_i}
    @nil_cyclists.each {|item| @sorted_cyclists << item}
    @cyclists = @sorted_cyclists
=end    
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

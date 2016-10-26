class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :require_oauth
  helper_method :points_in_stage

  def require_oauth    
  	if session[:access_token].nil? and session[:admin_user] == false or session[:admin_user].nil?
  		flash[:danger] = "You must connect to strava."
  		redirect_to root_path
  	end
  end 

  def sort_cyclists_stage(cyclists, stage)
    sorted_cyclists = []
    nil_cyclists = []

    cyclists.each_with_index do |cyclist, index|
      stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
      if stage_effort
        elapsed_time = stage_effort.elapsed_time # if stage_effort.elapsed_time
        if stage_effort.elapsed_time.to_i > 0
          sorted_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => elapsed_time, 'point' =>5}
        else
          nil_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => 0, 'point' => nil}
        end
      else
        nil_cyclists << { 'cyclist' => cyclist, 'elapsed_time' => nil, 'point' => nil}
      end
    end

    sorted_cyclists.sort_by!{|k| k['elapsed_time'].to_i}
    nil_cyclists.each {|item| sorted_cyclists << item}

    result = []
    sorted_cyclists.each { |item| result << item['cyclist']}    
    return result
  end

  # To use in Overall leaderboard
  def sort_cyclists_race(race)
    sorted_cyclists = []
    nil_cyclists = []
    stage_max_points = Array.new(race.stages.count, 1)

    race.stages.each_with_index do |stage, index|
      race.cyclists.each do |cyclist|      
        stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
        stage_max_points[index] = stage_max_points[index] + 1 if stage_effort
      end
    end

    race.cyclists.each_with_index do |cyclist, index|      
      total_time = 0
      total_points = 0
      stage_effort = nil

      race.stages.each_with_index do |stage, ix_stage|
        today = Time.now.to_date
        if stage.close_date >= today
          stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
          if stage_effort
            total_time = total_time + stage_effort.elapsed_time.to_i unless stage_effort.elapsed_time.nil?
            total_points = total_points + stage_effort.points.to_i
            total_time = total_time if stage_effort.elapsed_time if stage_effort.elapsed_time.nil?
          else
            #break
            total_points = total_points + stage_max_points[ix_stage]
          end
        end
      end

      if total_time > 0
        sorted_cyclists << { 'cyclist' => cyclist, 'total_time' => total_time, 'total_points' => total_points} 
      else
        nil_cyclists <<  { 'cyclist' => cyclist,  'total_time' => 'DNF', 'total_points' => total_points} 
      end
    end

    nil_cyclists.sort_by!{|a| a['total_points']}

    #sorted_cyclists.sort_by!{|k| k['total_points'].to_i}.reverse!
    sorted_cyclists.sort! do |a, b|
      [a['total_points'], a['total_time']] <=> [b['total_points'], b['total_time']]
    end

    return sorted_cyclists + nil_cyclists
  end 

  def points_in_stage(place)
    points_array = [50, 30, 20, 18, 16, 14, 12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    places_count = 16
    if place > places_count
      points_array[15]
    else
      points_array[place - 1]
    end
  end
  
end

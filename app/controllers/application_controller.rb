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
        today = Time.now.to_date # race.stages.last.close_date
        if stage.close_date >= today
          stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
          if stage_effort
            total_time = total_time + stage_effort.elapsed_time.to_i
            total_points = total_points + stage_effort.points.to_i
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

  # To use in Overall leaderboard by Tom Jean
  def sort_cyclists_race_stage(race, current_stage)
    sorted_cyclists = []
    nil_cyclists = []
    stage_max_points = Array.new(race.stages.count, 0)

    race.stages.each_with_index do |stage, index|
      race.cyclists.each do |cyclist|      
        stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
        stage_max_points[index] = stage_max_points[index] + 1 if stage_effort
      end
      break if stage == current_stage # condition to determine which stage is 
    end

    race.cyclists.each_with_index do |cyclist, index|      
      total_time = 0
      total_points = 0
      stage_effort = nil
      stage_count = 0

      race.stages.each_with_index do |stage, ix_stage|
        today = Time.now.to_date # race.stages.last.close_date
        # if race.stages.last.close_date >= today
          stage_effort = cyclist.stage_efforts.find_by(stage_id: stage)
          if stage_effort
            total_time = total_time + stage_effort.elapsed_time.to_i
            total_points = total_points + stage_effort.points.to_i
            stage_count -= 1            
          else
            #break
            total_points = total_points + stage_max_points[ix_stage] + 1
          end
        # end
        break if stage == current_stage # condition to determine which stage is 
      end

      if total_time > 0
        sorted_cyclists << { 'cyclist' => cyclist, 'total_time' => total_time, 'total_points' => total_points, 'stage_count' => stage_count} 
      else
        nil_cyclists <<  { 'cyclist' => cyclist,  'total_time' => 'DNF', 'total_points' => total_points, 'stage_count' => stage_count} 
      end
    end

    nil_cyclists.sort_by!{|a| a['total_points']}

    #sorted_cyclists.sort_by!{|k| k['total_points'].to_i}.reverse!
    sorted_cyclists.sort! do |a, b|
      [a['total_points'], a['stage_count'], a['total_time']] <=> [b['total_points'], b['stage_count'], b['total_time']]
    end

    return sorted_cyclists + nil_cyclists
  end

  # Overall leaderboard result for each stage... by Tom Jean
  def sort_cyclists_race_stage_list(race)
    sorted_cyclists_stage = [] 
    race.stages.each do |stage|
      item = sort_cyclists_race_stage(race, stage)
      sorted_cyclists_stage << item
    end
    return sorted_cyclists_stage
  end

  # Available races by Tom Jean
  def available_races
    available_races = []
    Race.all.each do |race|
      today = Time.now.to_date
      if today <= race.stages.first.close_date
        available_races << race
      end
    end
    return available_races    
  end

  # Cyclist result by Tom Jean...
  def cyclist_result (cyclist, race)
    cyclist_result = []    
      if race.nil?
          cyclist.rosters.each do |roster|
            race = Race.find(roster.race_id)
            race.stages.each do |stage|
              stage_effort = cyclist.stage_efforts.find_by(stage_id: stage.id)
              race_name = "#{race.name} - #{stage.name}"
              time = stage_effort ? stage_effort.elapsed_time.to_i : 'DNF'
              strava_url = stage_effort ? stage_effort.strava_activity_url : 'DNF'
              avg_watts = stage_effort ? "#{stage_effort.segment_avg_watts.to_f.round(2)}&nbsp;w" : 'DNF'
              temp = stage_effort.segment_avg_watts.to_f / cyclist.weight.to_f unless cyclist.weight.to_f == 0 and !stage_effort
              watts_per_k = temp ? "#{temp.to_f.round(2)}&nbsp;w/kg" : 'DNF'
              time_stamp = stage_effort ? stage_effort.create_date.to_i : 'DNF'
              cyclist_result << { 
                                'race'        => race_name,
                                'stage'       => stage.stage_no, 
                                'time'        => time, 
                                'strava_url'  => strava_url, 
                                'avg_watts'   => avg_watts, 
                                'watts_per_k' => watts_per_k, 
                                'time_stamp'  => time_stamp
                              }
            end
          end            
      else
        race.stages.each do |stage|
          stage_effort = cyclist.stage_efforts.find_by(stage_id: stage.id)
          race_name = "#{race.name} - #{stage.name}"
          puts race_name
          time = stage_effort ? stage_effort.elapsed_time.to_i : 'DNF'
          strava_url = stage_effort ? stage_effort.strava_activity_url : 'DNF'
          avg_watts = stage_effort ? "#{stage_effort.segment_avg_watts.to_f.round(2)}&nbsp;w" : 'DNF'
          temp = stage_effort.segment_avg_watts.to_f / cyclist.weight.to_f unless cyclist.weight.to_f == 0 and !stage_effort
          watts_per_k = temp ? "#{temp.to_f.round(2)}&nbsp;w/kg" : 'DNF'
          time_stamp = stage_effort ? stage_effort.create_date.to_i : 'DNF'
          cyclist_result << { 'race'=> race_name, 'stage'=> stage.stage_no, 'time'=> time, 'strava_url'=> strava_url, 'avg_watts'=> avg_watts, 'watts_per_k' => watts_per_k, 'time_stamp'  => time_stamp }
        end
      end
    
    return cyclist_result
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

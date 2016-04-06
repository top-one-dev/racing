namespace :strava do
	task :auto_update => :environment do
		today = Time.now.to_date
		#today = Date.new(2016, 4, 5)
		puts "Today is #{today}"
		stages = Stage.all

		stages.each do |stage|
			if stage.active_date <= today and stage.close_date >= today
				cyclists = stage.race.cyclists
				segments = stage.segments
				#puts "#{stage.name} #{stage.active_date} #{stage.close_date} "
				cyclists.each do |cyclist|
					begin 
						client = Strava::Api::V3::Client.new(:access_token => cyclist.access_token)
						results = client.list_athlete_activities
					rescue 
						puts "the request failed : #{cyclist.name} list_athlete_activities"
					else
						#puts "#{cyclist.name} #{cyclist.strava_id}"
						unless results.nil?
							results.each do |r|
								start_date = Date.parse(r["start_date_local"])
								# the activity is on active days?
								if stage.active_date <= start_date and stage.close_date >= start_date
									#puts "-----matched activity start on #{r["start_date"]}, #{r["id"]}------"
									# request activities from strava.com
									activity_id = r["id"]
									unless stage.stage_efforts.exists?(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
										auth_param = 'Bearer ' + cyclist.access_token
								        begin
									        result = RestClient.get "https://www.strava.com/api/v3/activities/#{activity_id}?include_all_efforts=true", :Authorization => auth_param          
									        result_json = JSON.parse(result)
									    rescue
									    	puts "the strava request failed."
									    else 
									        # match activities ids and stages segment ids
									        matched_segment_effort_ids = []
									        unless result_json['segment_efforts'].nil?
									            stage.segments.each do |segment|
									              result_json['segment_efforts'].each do |segment_effort|
									                if segment_effort['segment']['id'] == segment.strava_segment_id	and not matched_segment_effort_ids.include?(segment_effort['id'])
									                	matched_segment_effort_ids << segment_effort['id']
									                end
									              end
									            end
									        end

									        # If the activity includes segment efforts for segement of stage
									        if matched_segment_effort_ids.count == stage.segments.count 
						                		puts "Stage-#{stage.name} #{stage.active_date}-#{stage.close_date}"
						                		puts "Joined cyclist-#{cyclist.name} #{cyclist.strava_id}"
							                	puts "Found a new activity-start date #{r["start_date"]}, #{r["id"]}"
							                	puts "The activity's segment is #{matched_segment_effort_ids}"

							                  	stage_effort = stage.stage_efforts.build(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
												stage_effort.cyclist = cyclist
											    stage_effort.save
											end
									    end
									end
								end
							end
						end
					end
					#StageEffortsController.new.update_points(stage.race, stage)
				end				
			end
		end

		#update points
		puts "Updating cyclists points and ranking per stage and race."
		st = StageEffortsController.new
		stages.each do |stage|
			st.update_points(stage.race, stage)
		end
	end

	task :manual_update => :environment do
		#today = Time.now.to_date
		today = Date.new(2016, 4, 5)
		puts "Today is #{today}"
		stages = Stage.all

		stages.each do |stage|
			if stage.active_date <= today and stage.close_date >= today
				cyclists = stage.race.cyclists
				segments = stage.segments
				#puts "#{stage.name} #{stage.active_date} #{stage.close_date} "
				#cyclists.each do |cyclist|
				cyclist = Cyclist.find(47)
					begin 
						client = Strava::Api::V3::Client.new(:access_token => "110121abf5d6fb6165e26c48c69ea25cc8405d95")
						results = client.list_athlete_activities
					rescue 
						puts "the request failed : #{cyclist.name} list_athlete_activities"
					else
						#puts "#{cyclist.name} #{cyclist.strava_id}"
						unless results.nil?
							results.each do |r|
								start_date = Date.parse(r["start_date_local"])
								# the activity is on active days?
								if stage.active_date <= start_date and stage.close_date >= start_date
									#puts "-----matched activity start on #{r["start_date"]}, #{r["id"]}------"
									# request activities from strava.com
									print "Today is #{start_date}"
									activity_id = r["id"]
									unless stage.stage_efforts.exists?(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
										auth_param = 'Bearer ' + "110121abf5d6fb6165e26c48c69ea25cc8405d95"
										print "Reading activity"
								        begin
									        result = RestClient.get "https://www.strava.com/api/v3/activities/#{activity_id}?include_all_efforts=true", :Authorization => auth_param          
									        result_json = JSON.parse(result)
									    rescue
									    	puts "the strava request failed."
									    else 
									        # match activities ids and stages segment ids
									        matched_segment_effort_ids = []
									        print "Matching activities"
									        unless result_json['segment_efforts'].nil?
									            stage.segments.each do |segment|
									              result_json['segment_efforts'].each do |segment_effort|
									                if segment_effort['segment']['id'] == segment.strava_segment_id	and not matched_segment_effort_ids.include?(segment_effort['id'])
									                	matched_segment_effort_ids << segment_effort['id']
									                	print "-#{segment_effort['id']}-"
									                end
									              end
									            end
									        end

									        # If the activity includes segment efforts for segement of stage
									        print matched_segment_effort_ids
									        print "stage segment count is #{stage.segments.count}"
									        if matched_segment_effort_ids.count == stage.segments.count 
						                		puts "Stage-#{stage.name} #{stage.active_date}-#{stage.close_date}"
						                		
							                	puts "Found a new activity-start date #{r["start_date"]}, #{r["id"]}"
							                	puts "The activity's segment is #{matched_segment_effort_ids}"

							                  	stage_effort = stage.stage_efforts.build(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
												stage_effort.cyclist = cyclist
											    stage_effort.save
											end
									    end
									end
								end
							end
						end
					#end
					#StageEffortsController.new.update_points(stage.race, stage)
				end				
			end
		end

		#update points
		puts "Updating cyclists points and ranking per stage and race."
		st = StageEffortsController.new
		stages.each do |stage|
			st.update_points(stage.race, stage)
		end
	end
end
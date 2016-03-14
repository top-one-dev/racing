namespace :strava do
	task :auto_update => :environment do
		today = Time.now.to_date
		today = Date.new(2016, 3, 9)
		puts "Today is #{today}"
		stages = Stage.all
=begin
		client = Strava::Api::V3::Client.new(:access_token => client.access_token)
		results = client.list_athlete_activities


		#open("activity.json", "w") do |f|
		#	f.puts results 
		#end

		results.each do |r|
			start_date = Date.parse(r["start_date"])
			if start_date >= today
				puts start_date 
				activity = client.retrieve_an_activity(r["id"])
				open(r["id"].to_s + ".json", "w") do |f|
					f.puts activity 
				end
			end
		end
=end

		stages.each do |stage|
			if stage.active_date <= today and stage.close_date >= today
				cyclists = stage.race.cyclists
				segments = stage.segments
				puts "#{stage.name} #{stage.active_date} #{stage.close_date} "
				cyclists.each do |cyclist|					
					client = Strava::Api::V3::Client.new(:access_token => cyclist.access_token)
					results = client.list_athlete_activities
					puts "#{cyclist.name} #{cyclist.strava_id}"
					results.each do |r|
						start_date = Date.parse(r["start_date"])
						# when stage is active?
						if stage.active_date <= start_date and stage.close_date >= start_date

							puts "-----matched activity start on #{r["start_date"]}, #{r["id"]}------"
							# request activities from strava.com
							activity_id = r["id"]
							auth_param = 'Bearer ' + cyclist.access_token

					        #auth_param = 'Bearer ' + '8b4cf48c943d70868b1224d23268e19ed8e80c2d'
					        result = RestClient.get "https://www.strava.com/api/v3/activities/#{activity_id}?include_all_efforts=true", :Authorization => auth_param          
					        result_json = JSON.parse(result)

					        # match activities ids and stages segment ids
					        unless result_json['segment_efforts'].nil?
					            stage.segments.each do |segment|
					              result_json['segment_efforts'].each do |segment_effort|
					                if segment_effort['segment']['id'] == segment.strava_segment_id
					                	#start_date = Date.parse(segment_effort['start_date'])
					                	#if stage.active_date <= start_date and stage.close_date >= start_date
					                	puts "-----matched activity id is #{segment_effort['segment']['id']}-----"
						                	unless stage.stage_efforts.exists?(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
							                  	stage_effort = stage.stage_efforts.build(:strava_activity_url => "https://www.strava.com/activities/" + activity_id.to_s)
												stage_effort.cyclist = cyclist
											    stage_effort.save
											end
										#end
					                end
					              end
					            end
					        end
						end
					end
					#update_points(stage.race, stage)
				end				
			end
		end		
	end
end
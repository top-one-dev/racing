namespace :strava do
	desc "Pick a random"
	task :auto_update => :environment do
		today = Time.now.to_date
		today = Date.new(2016, 3, 9)
		puts "Today is #{today}"
		stages = Stage.all
=begin	
		client = Strava::Api::V3::Client.new(:access_token => '9f874434ae7ac4498258620d1a9d3d663aa4e4b0')
		results = client.list_athlete_activities
		results.each do |r|
			start_date = Date.parse(r["start_date"])
			puts start_date >= today
		end
=end

		stages.each do |stage|
			if stage.active_date <= today and stage.close_date >= today
				cyclists = stage.race.cyclists
				segments = stage.segments
	        
				cyclists.each do |cyclist|					
					client = Strava::Api::V3::Client.new(:access_token => cyclist.access_token)
					results = client.list_athlete_activities
					results.each do |r|
						start_date = Date.parse(r["start_date"])
						if stage.active_date <= start_date and stage.close_date >= start_date
							unless StageEffort.exists?(['strava_activity_url LIKE ?', "%#{r["id"]}%"])
								puts "Stage-#{stage.name} is active."
								puts "#{cyclist.name} #{cyclist.strava_id}"	
								stage_effort = stage.stage_efforts.build(:strava_activity_url => "https://www.strava.com/activities/" + r["id"].to_s)
								stage_effort.cyclist = cyclist
							    stage_effort.save
							end
						end
					end
				end
			end
		end
	end
end
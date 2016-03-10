namespace :strava do
	desc "Pick a random"
	task :auto_update => :environment do
		today = Time.now.to_date
		today = Date.new(2016, 3, 9)
		puts "Today is #{today}"
		stages = Stage.all
		stages.each do |stage|
			if stage.active_date <= today and stage.close_date >= today
				puts "Stage-#{stage.name} is active."
				cyclists = stage.race.cyclists
				segments = stage.segments
				cyclists.each do |cyclist|					
					puts "#{cyclist.name} #{cyclist.strava_id}"
					@client = Strava::Api::V3::Client.new(:access_token => cyclist.access_token)
					results = @client.list_athlete_activities
					results.each do |r|
						unless StageEffort.exists?(['strava_activity_url LIKE ?', "%#{r["id"]}%"])
							stage_effort = StageEffort.new(:strava_activity_url => "https://www.strava.com/activities/" + r["id"].to_s)	
							stage_effort.cyclist = cyclist
							stage_effort.stage = stage
							stage_effort.save!
							puts "-#{r["id"]}-"
							#segment_effects = @client.retrieve_an_activity(r["id"])
							#puts segment_effects
						end
					end
				end
			end
		end
	end
end
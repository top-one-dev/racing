module StravaClient
	extend ActiveSupport::Concern
	def strava_client(access_token)		
		client = Strava::Api::V3::Client.new(:access_token => access_token)  		
	end

	def strava_client
		client = Strava::Api::V3::Client.new(Cyclist.first.access_token)
	end
end
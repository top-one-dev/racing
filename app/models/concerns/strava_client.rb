module StravaClient
	extend ActiveSupport::Concern

	def strava_client
		client = Strava::Api::V3::Client.new(:access_token => "3a777777ca9e505c93514906e3956ddc6edfba7f")  		
	end
end
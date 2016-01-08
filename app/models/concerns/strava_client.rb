module StravaClient
	extend ActiveSupport::Concern

	def strava_client
		client = Strava::Api::V3::Client.new(:access_token => "6f56c7b2e6461816426e0ef1034a8146ad5f2cee")  		
	end
end
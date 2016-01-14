module StravaClient
	extend ActiveSupport::Concern
	def strava_client(access_token)		
		client = Strava::Api::V3::Client.new(:access_token => access_token)  		
	end

	def default_strava_client		
		client = Strava::Api::V3::Client.new(:access_token => 'f9e5eab5210b430fc162b1451aa2c5f2b8ab3d1c')  				
	end
end
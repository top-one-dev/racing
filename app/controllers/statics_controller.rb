class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def reuqest
  	@url = params[:request][:request_url]
  	
  	@url = URI.decode(@url)
  	auth_param = "Bearer #{session[:access_token]}"
  	begin
  		@result = RestClient.get @url, :Authorization => auth_param
  	rescue 
  		puts "the strava request failed."
  	end
  		
  end

end

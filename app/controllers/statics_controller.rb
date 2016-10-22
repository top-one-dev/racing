class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def request
  	@re = request_params.to_s
  	@url = request_params[:request_url] 	
  	@url = URI.decode(@url)
  	auth_param = "Bearer #{session[:access_token]}"
  	begin
  		@result = RestClient.get @url, :Authorization => auth_param
  	rescue 
  		puts "the strava request failed."
  	end  		
  end

  def request_params
      params.require(:request).permit(:request_url)
  end

end

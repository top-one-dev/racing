class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def reuqest
  	@url = params[:reuqest][:request_url] unless params[:reuqest][:request_url].nil?
  	@url = URI.decode(@url)
  	auth_param = "Bearer #{session[:access_token]}"
  	@result = RestClient.get @url, :Authorization => auth_param 	
  end

end

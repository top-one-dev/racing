class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def reuqest
  	@url = params[:reuqest][:request_url] unless params[:reuqest][:request_url].nil?
  	auth_param = 'Bear 13fdde1e1a15e14302c45c9cbc4ecbd415ef00e8'
  	@result = RestClient.get @url, :Authorization => auth_param unless @url.nil?  	
  end

end

class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def reuqest
  	@url = params[:url] unless params[:url].nil?
  	@result = RestClient.get @url unless @url.nil?  	
  end

end

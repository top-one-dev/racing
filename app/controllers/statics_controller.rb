class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end

  def request
  	if defined? params[:request][:request_url]
	  	@url = params[:request][:request_url] 
	  	auth_param = "Bearer #{session[:access_token]}"
	  	unless @url.nil?	  		
		  	@result = RestClient.get URI.decode(@url), :Authorization => auth_param		  	
	  	end
  	end  		
  end 

end

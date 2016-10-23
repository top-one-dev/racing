class RequestController < ApplicationController
	def index
				 		
	end

	def athlet
		@title = 'Athlete JSON Preview'
		if defined? params[:request][:request_url]
	  	@url = params[:request][:request_url] 
	  	auth_param = "Bearer #{session[:access_token]}"
	  	 unless @url.nil?	  		
		 	@result = RestClient.get URI.decode(@url), :Authorization => auth_param		
	  	 end
  		end  
	end

	def activity
		@title = 'Activity JSON Preview'
		if defined? params[:request][:request_url]
	  	@url = params[:request][:request_url] 
	  	auth_param = "Bearer #{session[:access_token]}"
	  	 unless @url.nil?	  		
		 	@result = RestClient.get URI.decode(@url), :Authorization => auth_param		
	  	 end
  		end  
	end

	
end

class RequestController < ApplicationController
	def index
		if defined? params[:request][:request_url]
	  	@url = params[:request][:request_url] 
	  	auth_param = "Bearer #{session[:access_token]}"
	  	 unless @url.nil?	  		
		 	@result = RestClient.get URI.decode(@url), :Authorization => auth_param		  	
	  	 end
  		end  		 		
	end

	def json_render json_data
		json_data.gsub(',', ',<br>');
		return raw(json_data)
	end
end

class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  	redirect_to get_token_path if session[:access_token]
  end


end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :require_oauth

  def require_oauth
  	if session[:access_token].nil?
  		flash[:error] = "You mush connect to strava."
  		redirect_to root_path
  	end
  end 
end

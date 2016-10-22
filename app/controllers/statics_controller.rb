class StaticsController < ApplicationController
  skip_before_action :require_oauth
  def home
  	#session[:access_token] = nil
  end


end

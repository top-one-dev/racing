class StaticsController < ApplicationController
  def home
  	session[:access_token] = nil
  end
end

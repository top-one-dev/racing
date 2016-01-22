class AdminController < ApplicationController
  skip_before_action :require_oauth

  def index

  end

  def authorize  	
  	user = AdminUser.authenticate(params[:username], params[:password])  	
  	if user
  	  session[:admin_user] = true
  	  #redirect_to admin_path, :notice => "Admin user has logged in successfully!"      
      redirect_to races_path, :notice => "Admin user has logged in successfully!"      
  	else
  	  session[:admin_user] = false
        flash[:danger] = "Invalid username or password"
  	  render "index"
  	end
  end

  def destroy
    session[:admin_user] = false
    redirect_to root_path, :notice => "Admin user has logged out!"
  end
end

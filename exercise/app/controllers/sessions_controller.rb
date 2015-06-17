class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		remember user
  		redirect_to edit_user_path(current_user)
  	else
  		flash[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
	log_out if logged_in?
	redirect_to login_url		
  end

end

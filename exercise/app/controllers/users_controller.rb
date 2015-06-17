class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def edit
  	@user = User.find(params[:id])
  	@users = User.all
  end	

  def create
  	@user = User.new(user_params)
  	if @user.save
  		log_in @user
  		flash[:success] = "ok"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "ok updated"
  		redirect_to edit_user_path(current_user)
  	else
  		render 'edit'
  	end
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  	end
end

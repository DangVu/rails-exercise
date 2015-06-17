# encoding: utf-8

class SessionsController < ApplicationController
  
  def redirect
    redirect_to root_url.to_s + '/auth/google_oauth2'
  end
  
  def create
   auth = request.env["omniauth.auth"]
   email = auth['info']['email']
   user = User.find_by_email(email)
   if (user)
     # Sign the user in and redirect to the destination page
     sign_in(user)
     redirect_to root_path
   else
     flash.now[:error] = 'Không tìm thấy người dùng nào với địa chỉ email: ' + email.to_s
     render 'new'
   end
  end

  def destroy
    sign_out
    redirect_to login_url
  end
end

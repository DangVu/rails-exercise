module SessionsHelper
  def sign_in(user)
    session[:current_user] = user
  end

  def sign_out
    session[:current_user] = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= session[:current_user]
  end

  def signed_in?
    !current_user.nil?
  end
end

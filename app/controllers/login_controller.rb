class LoginController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:login][:email].downcase)
    if user && user.authenticate(params[:login][:password])
      log_in(user)
      redirect_to store_shifts_path(current_user.store)
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to new_login_url
  end
end

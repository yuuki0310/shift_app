class LoginController < ApplicationController
  include LoginHelper
  
  def new
  end

  def create
    user = User.find_by(email: params[:login][:email].downcase)
    if user && user.authenticate(params[:login][:password])
      log_in(user)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

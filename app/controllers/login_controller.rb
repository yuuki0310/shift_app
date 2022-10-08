class LoginController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
  end

  def create
    user = User.find_by(email: params[:login][:email].downcase)
    if user && user.authenticate(params[:login][:password])
      log_in(user)
      flash[:notice] = "ログインしました"
      if current_user.store_id
        redirect_to current_shift
      else
        redirect_to new_user_affiliation_application_path(current_user)
      end
    else
      flash[:notice] = "ログインに失敗しました"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    # session.delete(:user_id)
    # session[:user_id] = 1
    # @current_user = 1
    # reset_session
    flash[:notice] = "ログアウトしました"
    redirect_to new_login_url
  end
end

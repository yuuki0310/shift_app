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
        redirect_to store_shift_section_index_path(current_user.store.id)
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
    flash[:notice] = "ログアウトしました"
    redirect_to new_login_url
  end
end

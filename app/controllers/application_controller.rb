class ApplicationController < ActionController::Base
  protect_from_forgery
  include LoginHelper
  # before_action :set_current_user
  
  # def set_current_user
  #   session[:user_id] = 2
  #   @current_user = User.find_by(id: session[:user_id])
  # end

  private
  def logged_in_user
    unless logged_in?
      flash[:notice] = "ログインが必要です"
      redirect_to new_login_path
    end
  end

  def owned_in_user
    unless owner?(params[:store_id])
      flash[:notice] = "オーナーのみが編集可能です"
      redirect_to new_login_path
    end
  end
end

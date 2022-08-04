class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_current_user
  
  def set_current_user
    session[:user_id] = 9
    @current_user = User.find_by(id: session[:user_id])
  end
end

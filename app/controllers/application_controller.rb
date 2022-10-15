class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include LoginHelper
  require "date"

  private
  def logged_in_user
    unless logged_in?
      flash[:notice] = "ログインが必要です"
      redirect_to new_login_path
    end
  end

  def current_user_authenticate
    user = User.find(return_user_id)
    unless current_user?(user)
      flash[:notice] = "本人のみ閲覧可能です"
      redirect_to new_login_path
    end
  end

  def store_staff
    unless store_staff?
      flash[:notice] = "スタッフのみが閲覧可能です"
      redirect_to new_login_path
    end
  end

  def owner_permission
    unless owner?
      flash[:notice] = "オーナーのみが編集可能です"
      redirect_to new_login_path
    end
  end

  def store_independent
    if logged_in? && current_user.store_id.nil?
      flash[:notice] = "店舗無所属になっています"
      redirect_to new_user_affiliation_application_path(current_user)
    end
  end

  def store_affiliation
    unless logged_in? && current_user.store_id.nil?
      redirect_to store_shift_section_index_path(current_user.store.id)
    end
  end

end

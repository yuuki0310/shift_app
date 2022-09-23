class ApplicationController < ActionController::Base
  protect_from_forgery
  include LoginHelper
  helper_method :current_shift
  require "date"

  def current_shift
    store_shift_sections = StoreShiftSubmission.where(store_id: current_user.store.id)
    store_shift_sections.each do |store_shift_section|
      if store_shift_section.beginning <= Date.today && Date.today <= store_shift_section.ending
        return "/stores/#{current_user.store.id}/shifts/#{store_shift_section.beginning}"
      else
        return store_shift_section_index_path(current_user.store.id)
      end
    end
  end
      

  private
  def logged_in_user
    unless logged_in?
      flash[:notice] = "ログインが必要です"
      redirect_to new_login_path
    end
  end

  def current_user_authenticate
    user = User.find(params[:user_id])
    unless current_user?(user)
      flash[:notice] = "本人のみ閲覧可能です"
      redirect_to new_login_path
    end
  end

  def store_staff
    unless owner?(params[:store_id])
      flash[:notice] = "スタッフのみが閲覧可能です"
      redirect_to new_login_path
    end
  end

  def owner_permission
    unless owner?(params[:store_id])
      flash[:notice] = "オーナーのみが編集可能です"
      redirect_to new_login_path
    end
  end

  def store_independent
    if logged_in? && current_user.store_id.nil?
      redirect_to new_user_affiliation_application_path(current_user)
    end
  end

  def store_affiliation
    unless logged_in? && current_user.store_id.nil?
      redirect_to current_shift
    end
  end

end

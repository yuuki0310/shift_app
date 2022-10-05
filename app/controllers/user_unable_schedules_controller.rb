class UserUnableSchedulesController < ApplicationController
  before_action :logged_in_user, :store_independent, :current_user_authenticate
  include CalendarHelper

  def user_unable_schedule_params
    params.require(:user_unable_schedule).permit(:user_id, :date, :working_time_from, :working_time_to).merge(user_id: @current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @shift_section = ShiftSection.find_by(store_id: @user.store.id, beginning: params[:beginning])
    @user_unable_schedule = UserUnableSchedule.new
    @user_unable_schedules = UserUnableSchedule.where(user_id: params[:user_id], date: @shift_section.beginning..@shift_section.ending)
    if UserSubmission.find_by(user_id: params[:user_id], shift_section_id: @shift_section.id)
      @submission = UserSubmission.find_by(user_id: params[:user_id], shift_section_id: @shift_section.id)
    else
      @submission = UserSubmission.new
    end
  end

  def index
    store = User.find(params[:user_id]).store
    @store_shift_sections = ShiftSection.where(store_id:store.id)
  end

  def create
    @user_unable_schedule = UserUnableSchedule.new(user_unable_schedule_params)
    if @user_unable_schedule.save
      redirect_to "/users/#{params[:user_id]}/user_unable_schedules/#{params[:beginning]}/new"
    else
      render :new
    end
  end
  
  def destroy
    @user_unable_schedule  = UserUnableSchedule.find(params[:id])
    @user_unable_schedule.destroy
    redirect_to "/users/#{params[:user_id]}/user_unable_schedules/#{params[:beginning]}/new"
  end
end
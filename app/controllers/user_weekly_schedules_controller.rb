class UserWeeklySchedulesController < ApplicationController
  before_action :logged_in_user, :store_independent, :current_user_authenticate
  include CalendarHelper

  def user_weekly_schedule_params
    params.require(:user_weekly_schedule).permit(:working_time_from, :working_time_to, :user_id, weeklyday_id: []).merge(user_id: @current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @weeklydays = Weeklyday.all
    @shift_section = ShiftSection.find_by(store_id: @user.store.id, status: 1)
    @user_schedule = UserWeeklySchedule.new
    weekly_scheduled_times(UserWeeklySchedule.where(user_id: params[:user_id]))
  end
  
  def create
    @user = User.find(params[:user_id])
    shift_sections = ShiftSection.where(store_id: @user.store.id)
    @shift_section = shift_sections.find_by(status: 1)
    @user_schedule = UserWeeklySchedule.new
    weekly_scheduled
    if params[:user_weekly_schedule][:weeklyday_id]
      params[:user_weekly_schedule][:weeklyday_id].each do |weeklyday_id|
        @user_schedule = UserWeeklySchedule.new(user_weekly_schedule_params.merge(weeklyday_id: weeklyday_id))
        @user_schedule.save
      end
      if @user_schedule.save
        redirect_to new_user_user_weekly_schedule_path
      else
        render :new
      end
    else
      @user_schedule = UserWeeklySchedule.create(user_weekly_schedule_params)
      render :new
    end
  end
  
  def destroy
    UserWeeklySchedule.destroy(params[:id])
    redirect_to new_user_user_weekly_schedule_path
  end
end

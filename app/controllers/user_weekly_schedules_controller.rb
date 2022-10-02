class UserWeeklySchedulesController < ApplicationController
  before_action :logged_in_user, :store_independent, :current_user_authenticate
  helper_method :bar_line

  def user_weekly_schedule_params
    params.require(:user_weekly_schedule).permit(:working_time_from, :working_time_to, :user_id, weeklyday_id: []).merge(user_id: @current_user.id)
  end

  def weekly_scheduled
    @working_times = []
    UserWeeklySchedule.where(user_id: params[:user_id]).each do |user_schedule|
      @working_times.push(user_schedule.working_time_from)
      @working_times.push(user_schedule.working_time_to)
    end
    if @working_times.count > 2
      @working_times.uniq!
      @working_times.sort!
    end
    @weeklydays = Weeklyday.all
    def bar_line(weeklyday, working_time)
      user_weekly_schedules = UserWeeklySchedule.where(weeklyday_id: weeklyday, user_id: params[:user_id])
      user_weekly_schedules.each do |user_schedule|
        if user_schedule.working_time_from < working_time && working_time < user_schedule.working_time_to
          return true
          break
        end
      end
      return false
    end
  end

  def new
    @user = User.find(params[:user_id])
    @weeklydays = Weeklyday.all
    shift_sections = ShiftSection.where(store_id: @user.store.id)
    @shift_section = shift_sections.find_by(status: 1)
    @user_schedule = UserWeeklySchedule.new
    weekly_scheduled
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

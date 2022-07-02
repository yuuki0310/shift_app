class UserSchedulesController < ApplicationController

  helper_method :bar_line

  def userSchedule_params
    params.require(:user_schedule).permit(:working_time_from, :working_time_to, :user_id, weeklyday_id: []).merge(user_id: @current_user.id)
  end

  def weekly_scheduled
    @working_times = []
    @current_user.user_schedules.each do |user_schedule|
      @working_times.push(user_schedule.working_time_from)
      @working_times.push(user_schedule.working_time_to)
    end
    @working_times.uniq!.sort!
    @weeklydays = Weeklyday.all
    def bar_line(weeklyday, working_time)
      user_schedules = @current_user.user_schedules.where(weeklyday_id: weeklyday)
      user_schedules.each do |user_schedule|
        if user_schedule.working_time_from < working_time && working_time < user_schedule.working_time_to
          return true
          break
        end
      end
      return false
    end
  end

  def new
    @user_schedule = UserSchedule.new
    weekly_scheduled
  end
  
  def create
    @user_schedule = UserSchedule.new
    weekly_scheduled
    if params[:user_schedule][:weeklyday_id]
      params[:user_schedule][:weeklyday_id].each do |weeklyday_id|
        @user_schedule = UserSchedule.new(userSchedule_params.merge(weeklyday_id: weeklyday_id))
        @user_schedule.save
      end
      if @user_schedule.save
        redirect_to("/user_schedules/new")
      else
        render :new
      end
    else
      @user_schedule = UserSchedule.create(userSchedule_params)
      render :new
    end
  end
end

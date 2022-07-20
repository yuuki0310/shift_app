class UserUnableSchedulesController < ApplicationController

  helper_method :date_table

  def userUnableSchedule_params
    params.require(:user_unable_schedule).permit(:user_id, :date, :working_time_from, :working_time_to).merge(user_id: @current_user.id)
  end

  def date_table(date)
    def calendar_wday(date)
      if date.wday == 0
        return 7
      else
        return date.wday
      end
    end

    date_tables = []
    store_id = User.find(params[:user_id]).store_id
    date_schedules = StoreMonthSchedule.where(date: date, store_id: store_id)
    weekly_schedules = StoreSchedule.where(weeklyday_id: calendar_wday(date), store_id: store_id)
    weekly_schedules.each do |wekkly_schedule|
      date_tables.push(wekkly_schedule)
    end
    if date_schedules.present?
      date_schedules.each do |date_schedule|
        date_tables.push(date_schedule)
        weekly_schedules.each do |wekkly_schedule|
          if wekkly_schedule.working_time_from < date_schedule.working_time_from && date_schedule.working_time_from < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from < date_schedule.working_time_to && date_schedule.working_time_to < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from == date_schedule.working_time_from && wekkly_schedule.working_time_to == date_schedule.working_time_to
            date_tables.delete(wekkly_schedule)
          end
        end
      end
    end
    user_schedules = UserSchedule.where(weeklyday_id: calendar_wday(date), user_id: params[:user_id])
    date_tables.each do |date_table|
      user_schedules.each do |user_schedule|
        unless user_schedule.working_time_from < date_table.working_time_from && date_table.working_time_from < user_schedule.working_time_to || \
          user_schedule.working_time_from < date_table.working_time_to && date_table.working_time_to < user_schedule.working_time_to || \
          user_schedule.working_time_from == date_table.working_time_from && date_table.working_time_to == user_schedule.working_time_to then
          date_tables.delete(date_table)
        end
      end
    end
    user_unable_schedules = UserUnableSchedule.where(date: date, user_id: params[:user_id])
    if user_unable_schedules
      user_unable_schedules.each do |user_unable_schedule|
        date_tables.each do |date_table|
          if date_table.working_time_from < user_unable_schedule.working_time_from && user_unable_schedule.working_time_from < date_table.working_time_to || \
            date_table.working_time_from < user_unable_schedule.working_time_to && user_unable_schedule.working_time_to < date_table.working_time_to || \
            date_table.working_time_from == user_unable_schedule.working_time_from && date_table.working_time_to == user_unable_schedule.working_time_to
            date_tables.delete(date_table)
          end
        end
      end
    end
    date_tables.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return date_tables
  end

  def new
    @user = User.find(params[:user_id])
    @user_unable_schedule = UserUnableSchedule.new
    @user_unable_schedules = UserUnableSchedule.where(user_id: params[:user_id])
    if Submission.find_by(user_id: params[:user_id])
      @submission = Submission.find_by(user_id: params[:user_id])
    else
      @submission = Submission.new
    end
  end
  def create
    @user_unable_schedule = UserUnableSchedule.new(userUnableSchedule_params)
    if @user_unable_schedule.save
      redirect_to new_user_user_unable_schedule_path
    else
      render :new
    end
  end
  
  def destroy
    @user_unable_schedule  = UserUnableSchedule.find(params[:id])
    @user_unable_schedule.destroy
    redirect_to new_user_user_unable_schedule_path
  end
end
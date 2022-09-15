class UserUnableSchedulesController < ApplicationController
  before_action :logged_in_user
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
    user_schedules = UserSchedule.where(weeklyday_id: calendar_wday(date), user_id: params[:user_id])
    if user_schedules.empty?
      return []
    end
    weekly_schedules.each do |wekkly_schedule|
      date_tables.push(wekkly_schedule)
    end
    if date_schedules.present?
      date_schedules.each do |date_schedule|
        date_tables.push(date_schedule)
        weekly_schedules.each do |wekkly_schedule|
          if wekkly_schedule.working_time_from <= date_schedule.working_time_from && date_schedule.working_time_from < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from < date_schedule.working_time_to && date_schedule.working_time_to <= wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from == date_schedule.working_time_from && wekkly_schedule.working_time_to == date_schedule.working_time_to
            date_tables.delete(wekkly_schedule)
          end
        end
      end
    end
    user_date_tables = []
    date_tables.each do |date_table|
      user_schedules.each do |user_schedule|
        if user_schedule.working_time_from <= date_table.working_time_from && date_table.working_time_from < user_schedule.working_time_to || \
          user_schedule.working_time_from < date_table.working_time_to && date_table.working_time_to <= user_schedule.working_time_to || \
          user_schedule.working_time_from == date_table.working_time_from && date_table.working_time_to == user_schedule.working_time_to
          user_date_tables.push(date_table)
        end
      end
    end
    user_unable_schedules = UserUnableSchedule.where(date: date, user_id: params[:user_id])
    if user_unable_schedules
      user_unable_schedules.each do |user_unable_schedule|
        user_date_tables.each do |user_date_table|
          if user_date_table.working_time_from <= user_unable_schedule.working_time_from && user_unable_schedule.working_time_from < user_date_table.working_time_to || \
            user_date_table.working_time_from < user_unable_schedule.working_time_to && user_unable_schedule.working_time_to <= user_date_table.working_time_to || \
            user_date_table.working_time_from == user_unable_schedule.working_time_from && user_date_table.working_time_to == user_unable_schedule.working_time_to
            user_date_tables.delete(user_date_table)
          end
        end
      end
    end
    user_date_tables.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return user_date_tables
  end

  def new
    @user = User.find(params[:user_id])
    @store_shift_submission = StoreShiftSubmission.find_by(store_id: @user.store.id, beginning: params[:beginning])
    @user_unable_schedule = UserUnableSchedule.new
    @user_unable_schedules = UserUnableSchedule.where(user_id: params[:user_id])
    if Submission.find_by(user_id: params[:user_id])
      @submission = Submission.find_by(user_id: params[:user_id])
    else
      @submission = Submission.new
    end
  end

  def index
    store = User.find(params[:user_id]).store
    @store_shift_sections = StoreShiftSubmission.where(store_id:store.id)
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
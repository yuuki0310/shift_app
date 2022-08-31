class StoreMonthSchedulesController < ApplicationController
  before_action :logged_in_user
  before_action :owned_in_user, only: [:create, :destroy]
  helper_method :date_table

  def storeMonthSchedule_params
    params.require(:store_month_schedule).permit(:date, :working_time_from, :working_time_to, :count, :store_id).merge(store_id: @current_user.store.id)
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
    date_schedules = StoreMonthSchedule.where(date: date, store_id: params[:store_id])
    weekly_schedules = StoreSchedule.where(weeklyday_id: calendar_wday(date), store_id: params[:store_id])
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
    date_tables.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return date_tables
  end

  def new
    @store = Store.find(params[:store_id])
    @store_month_schedule = StoreMonthSchedule.new
  end
  
  def create
    @store = Store.find(params[:store_id])
    @store_month_schedule = StoreMonthSchedule.new(storeMonthSchedule_params)
    if @store_month_schedule.save
      redirect_to new_store_store_month_schedule_path
    else
      render :new
    end
  end
  def destroy
    StoreMonthSchedule.destroy(params[:id])
    redirect_to new_store_store_month_schedule_path
  end
end

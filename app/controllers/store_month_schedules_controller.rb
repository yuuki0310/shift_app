class StoreMonthSchedulesController < ApplicationController

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
    date_schedules = @current_user.store.store_month_schedules.where(date: date)
    weekly_schedules = @current_user.store.store_schedules.where(weeklyday_id: calendar_wday(date))
    if date_schedules.present?
      date_schedules.each do |date_schedule|
        weekly_schedules.each do |wekkly_schedule|
          if wekkly_schedule.working_time_from < date_schedule.working_time_from && date_schedule.working_time_from < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from < date_schedule.working_time_to && date_schedule.working_time_to < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from == date_schedule.working_time_from && wekkly_schedule.working_time_to == date_schedule.working_time_to
            date_tables.push(date_schedule)
          else
            date_tables.push(wekkly_schedule)
          end
        end
      end
      date_tables.uniq!
    else
      date_tables = weekly_schedules
    end
    return date_tables
  end

  def new
    @store_month_schedule = StoreMonthSchedule.new
    # @date_schedules = StoreMonthSchedule.all
  end
  
  def create
    @store_month_schedule = StoreMonthSchedule.new(storeMonthSchedule_params)
    if @store_month_schedule.save
      redirect_to("/store_month_schedules/new")
    else
      render :new
    end
  end
end

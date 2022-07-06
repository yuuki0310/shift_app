class StoreMonthSchedulesController < ApplicationController

  helper_method :calendar_wday

  def storeMonthSchedule_params
    params.require(:store_month_schedule).permit(:date, :working_time_from, :working_time_to, :count, :store_id).merge(store_id: @current_user.store.id)
  end

  def calendar_wday(date)
    if date.wday == 0
      return 7
    else
      return date.wday
    end
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

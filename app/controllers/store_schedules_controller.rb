class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: []).merge(store_id: @current_user.store.id)
  end
  
  def new
    @store_schedule = StoreSchedule.new
    @working_times = []
    @current_user.store.store_schedules.each do |store_schedule|
      @working_times.push(store_schedule.working_time_from)
      @working_times.push(store_schedule.working_time_to)
    end
    @working_times.sort!
  end
  
  def create
    @store_schedule = StoreSchedule.new
    if params[:store_schedule][:weeklyday_id]
      params[:store_schedule][:weeklyday_id].each do |weeklyday_id|
        @store_schedule = StoreSchedule.new(storeSchedule_params.merge(weeklyday_id: weeklyday_id))
        @store_schedule.save
      end
      if @store_schedule.save == false
        render("store_schedules/new")
      else
        redirect_to("/store_schedules/new")
      end
    else
      @store_schedule = StoreSchedule.create(storeSchedule_params)
      render("store_schedules/new")
    end
  end

  def update
  end

end

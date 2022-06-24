class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: [])
  end
  
  def new
    @store_schedule = StoreSchedule.new
  end
  
  def create
    @store_schedule = StoreSchedule.new
    if params[:store_schedule][:weeklyday_id]
      params[:store_schedule][:weeklyday_id].each do |weeklyday_id|
        @store_schedule = StoreSchedule.new(
          store_id: @current_user.id,
          weeklyday_id: weeklyday_id,
          working_time_from: storeSchedule_params[:working_time_from],
          working_time_to: storeSchedule_params[:working_time_to],
          count: storeSchedule_params[:count]
        )
        @store_schedule.save
      end
      if @store_schedule.save == false
        render("store_schedules/new")
      else
        redirect_to("/store_schedules/new")
      end
    else
      storeSchedule_params[:store_id] = @current_user.id
      @store_schedule = StoreSchedule.create(storeSchedule_params)
      render("store_schedules/new")
    end
  end

  def update
  end

end

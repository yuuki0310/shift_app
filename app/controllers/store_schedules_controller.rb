class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: [])
  end
  
  def new
    @store_schedule = StoreSchedule.new
  end
  
  def create
    params.require(:store_schedule).permit(weeklyday_id: [])[:weeklyday_id].each do |weeklyday_id|
      @store_schedule = StoreSchedule.new(
        store_id: @current_user.id,
        weeklyday_id: weeklyday_id,
        working_time_from: storeSchedule_params[:working_time_from],
        working_time_to: storeSchedule_params[:working_time_to],
        count: storeSchedule_params[:count]
      )
      @store_schedule.save
    end
    redirect_to("/store_schedules/new")
  end

  def update
  end

end

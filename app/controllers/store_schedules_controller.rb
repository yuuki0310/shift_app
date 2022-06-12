class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_ids: [])
  end

  def new
    @week = StoreSchedule.new
  end
  
  def create
    StoreSchedule.create(storeSchedule_params)
    redirect_to("/")
  end

  def update
  end

end

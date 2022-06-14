class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id)
  end

  def new
    @week = StoreSchedule.new
  end
  
  def create
    params.require(:store_schedule).permit(weeklyday_id: [])[:weeklyday_id].each do |weeklyday_id|
      StoreSchedule.create(storeSchedule_params)
    end

    redirect_to("/")
  end

  def update
  end

end

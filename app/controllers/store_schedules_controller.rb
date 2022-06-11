class StoreSchedulesController < ApplicationController

  def storeSchedule_params
    params.require(:store_schedule).permit(:weeklyday_id, :working_time_from, :working_time_to, :count, :store_id)
  end

  def new
    @week = StoreSchedule.new
  end
  
  def create
    # if storeSchedule_params
      
    # else
      
    # end
    StoreSchedule.create(storeSchedule_params)
    redirect_to("/")
  end

  def update
  end

end

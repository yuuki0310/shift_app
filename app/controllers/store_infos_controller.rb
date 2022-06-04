class StoreInfosController < ApplicationController

  def storeInfo_params
    params.require(:store_info).permit(:weeklyday, :working_time, :count, :user_id)
  end

  def new
    @week = StoreInfo.new
  end
  
  def create
    StoreInfo.create(storeInfo_params)
    redirect_to("/")
  end

  def update
  end

end

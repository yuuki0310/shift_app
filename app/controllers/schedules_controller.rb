class SchedulesController < ApplicationController
  def people
  end

  def week_set
    @week = StoreInfo.new(
      working_time: params[:working_time_from],
      count: params[:count],
      weeklyday: params[:weeklyday]
    )
    @week.save
    redirect_to("/")
  end
end

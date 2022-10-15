class StoreWeeklySchedulesController < ApplicationController
  before_action :logged_in_user, :store_staff, except:[:crate, :destroy]
  before_action :owner_permission, only: [:crate, :destroy]
  before_action :store_independent
  include CalendarHelper

  def store_weekly_schedule_params
    params.require(:store_weekly_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: []).merge(store_id: @current_user.store.id)
  end

  def new
    @store = Store.find(params[:store_id])
    @store_schedule = StoreWeeklySchedule.new
    @weeklydays = Weeklyday.all
    weekly_scheduled_times(StoreWeeklySchedule.where(store_id: params[:store_id]))
  end
  
  def create
    @store = Store.find(params[:store_id])
    @store_schedule = StoreWeeklySchedule.new
    @weeklydays = Weeklyday.all
    weekly_scheduled_times(StoreWeeklySchedule.where(store_id: params[:store_id]))
    if store_weekly_schedule_params[:weeklyday_id]
      store_weekly_schedule_params[:weeklyday_id].each do |weeklyday_id|
        @store_schedule = StoreWeeklySchedule.new(store_weekly_schedule_params.merge(weeklyday_id: weeklyday_id))
        @store_schedule.save
      end
      if @store_schedule.save
        redirect_to new_store_store_weekly_schedule_path
      else
        render :new
      end
    else
      @store_schedule = StoreWeeklySchedule.create(store_weekly_schedule_params)
      render :new
    end
    
    @store_month_schedule = StoreMonthSchedule.new
  end
  
  def destroy
    StoreWeeklySchedule.destroy(params[:id])
    redirect_to new_store_store_weekly_schedule_path
  end

end

class StoreWeeklySchedulesController < ApplicationController
  before_action :logged_in_user, :store_staff, except:[:crate, :destroy]
  before_action :owner_permission, only: [:crate, :destroy]
  before_action :store_independent
  helper_method :bar_line, :calendar_wday

  def StoreWeeklySchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: []).merge(store_id: @current_user.store.id)
  end

  def weekly_scheduled
    @working_times = []
    StoreWeeklySchedule.where(store_id: params[:store_id]).each do |store_schedule|
      @working_times.push(store_schedule.working_time_from)
      @working_times.push(store_schedule.working_time_to)
    end
    if @working_times.count > 2
      @working_times.uniq!
      @working_times.sort!
    end
    @weeklydays = Weeklyday.all
    def bar_line(weeklyday, working_time)
      store_weekly_schedules = StoreWeeklySchedule.where(weeklyday_id: weeklyday, store_id: params[:store_id])
      store_weekly_schedules.each do |store_schedule|
        if store_schedule.working_time_from < working_time && working_time < store_schedule.working_time_to
          return true
          break
        end
      end
      return false
    end
  end

  def new
    @store = Store.find(params[:store_id])
    @store_schedule = StoreWeeklySchedule.new
    weekly_scheduled
    @store_month_schedule = StoreMonthSchedule.new
  end
  
  def create
    @store = Store.find(params[:store_id])
    @store_schedule = StoreWeeklySchedule.new
    weekly_scheduled
    if params[:store_schedule][:weeklyday_id]
      params[:store_schedule][:weeklyday_id].each do |weeklyday_id|
        @store_schedule = StoreWeeklySchedule.new(StoreWeeklySchedule_params.merge(weeklyday_id: weeklyday_id))
        @store_schedule.save
      end
      if @store_schedule.save
        redirect_to new_store_store_weekly_schedule_path
      else
        render :new
      end
    else
      @store_schedule = StoreWeeklySchedule.create(StoreWeeklySchedule_params)
      render :new
    end
    
    @store_month_schedule = StoreMonthSchedule.new
  end
  
  def destroy
    StoreWeeklySchedule.destroy(params[:id])
    redirect_to new_store_store_weekly_schedule_path
  end

  def update
  end

end

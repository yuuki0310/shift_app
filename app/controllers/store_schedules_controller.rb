class StoreSchedulesController < ApplicationController

  helper_method :bar_line

  def storeSchedule_params
    params.require(:store_schedule).permit(:working_time_from, :working_time_to, :count, :store_id, weeklyday_id: []).merge(store_id: @current_user.store.id)
  end

  def weekly_scheduled
    @working_times = []
    @current_user.store.store_schedules.each do |store_schedule|
      @working_times.push(store_schedule.working_time_from)
      @working_times.push(store_schedule.working_time_to)
    end
    @working_times.uniq!.sort!
    @weeklydays = Weeklyday.all
    def bar_line(weeklyday, working_time)
      store_schedules = @current_user.store.store_schedules.where(weeklyday_id: weeklyday)
      store_schedules.each do |store_schedule|
        if store_schedule.working_time_from < working_time && working_time < store_schedule.working_time_to
          return true
          break
        end
      end
      return false
    end
  end
  
  def new
    @store_schedule = StoreSchedule.new
    weekly_scheduled
  end
  
  def create
    @store_schedule = StoreSchedule.new
    weekly_scheduled
    if params[:store_schedule][:weeklyday_id]
      params[:store_schedule][:weeklyday_id].each do |weeklyday_id|
        @store_schedule = StoreSchedule.new(storeSchedule_params.merge(weeklyday_id: weeklyday_id))
        @store_schedule.save
      end
      if @store_schedule.save
        redirect_to("/store_schedules/new")
      else
        render :new
      end
    else
      @store_schedule = StoreSchedule.create(storeSchedule_params)
      render :new
    end
  end

  def destroy
  end

  def update
  end

end

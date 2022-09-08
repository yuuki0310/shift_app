class ShiftsController < ApplicationController
  before_action :logged_in_user
  helper_method :date_table, :store_date_table, :available_staff_set, :original_date_range
  require "date"

  def date_table(date)
    def calendar_wday(date)
      if date.wday == 0
        return 7
      else
        return date.wday
      end
    end
    date_tables = []
    date_schedules = StoreMonthSchedule.where(date: date, store_id: params[:store_id])
    weekly_schedules = StoreSchedule.where(weeklyday_id: calendar_wday(date), store_id: params[:store_id])    
    weekly_schedules.each do |wekkly_schedule|
      date_tables.push(wekkly_schedule)
    end
    if date_schedules.present?
      date_schedules.each do |date_schedule|
        date_tables.push(date_schedule)
        weekly_schedules.each do |wekkly_schedule|
          if wekkly_schedule.working_time_from <= date_schedule.working_time_from && date_schedule.working_time_from < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from < date_schedule.working_time_to && date_schedule.working_time_to <= wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from == date_schedule.working_time_from && wekkly_schedule.working_time_to == date_schedule.working_time_to
            date_tables.delete(wekkly_schedule)
          end
        end
      end
    end
    date_tables.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return date_tables
  end


  
  def store_date_table(date)
    store_date_tables = {}
    date_table(date).each do |date_table|
      store_date_tables.store(date_table.working_time_from, [])
    end
    store = Store.find(params[:store_id])
    store.users.each do |user|
      if user.submission
        user_schedules = UserSchedule.where(weeklyday_id: calendar_wday(date), user_id: user.id)
        date_table(date).each do |date_table|
          user_schedules.each do |user_schedule|
            if user_schedule.working_time_from <= date_table.working_time_from && date_table.working_time_from < user_schedule.working_time_to || \
              user_schedule.working_time_from < date_table.working_time_to && date_table.working_time_to <= user_schedule.working_time_to || \
              user_schedule.working_time_from == date_table.working_time_from && date_table.working_time_to == user_schedule.working_time_to
              store_date_tables[date_table.working_time_from].push(user.id)
            end
          end
        end
        user_unable_schedules = UserUnableSchedule.where(date: date, user_id: user.id)
        if user_unable_schedules
          user_unable_schedules.each do |user_unable_schedule|
            date_table(date).each do |date_table|
              if date_table.working_time_from <= user_unable_schedule.working_time_from && user_unable_schedule.working_time_from < date_table.working_time_to || \
                date_table.working_time_from < user_unable_schedule.working_time_to && user_unable_schedule.working_time_to <= date_table.working_time_to || \
                date_table.working_time_from == user_unable_schedule.working_time_from && date_table.working_time_to == user_unable_schedule.working_time_to
                store_date_tables[date_table.working_time_from].delete(user.id)
              end
            end
          end
        end
      end
    end
    return store_date_tables
  end

  def original_date_range(beginning)
    ending = beginning.next_month - 1
    range = (beginning..ending).to_a
  # def date_range
    # beginning = Date.parse('2022-08-01').to_date
    # ending    = Date.parse('2022-09-01').to_date - 1
    # range = (beginning..ending).to_a

    if beginning.wday == 0
      6.times do
        range.unshift(nil)
      end
    elsif beginning.wday != 1
      (beginning.wday - 1).times do
        range.unshift(nil)
      end
    end
    return range    
  end


  def available_staff_set
    available_staff = []
    store_working_time_sum = 0
    @beginning = Date.parse('2022-08-01').to_date
    ending = @start_day.next_month - 1
    @beginning..ending.each do |date|
      date_table(date).each do |dt|
        store_working_time_sum += (dt.working_time_to - dt.working_time_from) * dt.count / 60
        store_date_table(date).each do |wtf, ids|
          if wtf == dt.working_time_from
            available_staff.push({date: date, working_time_from: wtf, working_time_to: dt.working_time_to, count: dt.count, ids: ids, working_staff: []})
          end
        end
      end
    end
    available_staff.sort! do |a, b|
      (b[:count].to_f / b[:ids].size.to_f) <=> (a[:count].to_f / a[:ids].size.to_f)
    end
    working_desired_time_sum = 0
    store = Store.find(params[:store_id])
    store.users.each do |user|
      if user.submission
        working_desired_time_sum += user.working_desired_time
      end
    end
    working_time_ratio  = {}
    # working_time_sum = {}
    store.users.each do |user|
      if user.submission
        working_time_ratio.store(user.id, store_working_time_sum * (user.working_desired_time.to_f / working_desired_time_sum.to_f))
        # working_time_sum.store(user.id, 0)
      end
    end
    available_staff.each do |as|
      working_time_ratio.sort_by { |k, v| -v }.to_h.each do |id, ratio|
        if as[:working_staff].size < as[:count] && as[:ids].include?(id)
          as[:working_staff].push(id)
          working_time_ratio[id] -= (as[:working_time_to] - as[:working_time_from]) / 60
          # working_time_sum[id] += (as[:working_time_to] - as[:working_time_from]) / 60
        end
      end
    end
    available_staff.sort! do |a, b|
      [a[:date], a[:working_time_from]] <=> [b[:date], b[:working_time_from]]
    end

    unless Shift.find_by(date: date_range)
      available_staff.each do |as|
        # as.reject { |k,v| k == :count || k == :ids || k == :working_staff }
        as[:working_staff].each do |ws|
          # as.reject { |k,v| }
          Shift.create(as.reject { |k,v| k == :count || k == :ids || k == :working_staff }.merge(store_id: current_user.store.id, user_id: ws))
        end
      end
    end 

    return available_staff#, working_time_sum
  end

  def index
    @store = current_user.store
    @beginning = Date.parse('2022-08-01').to_date
    @working_time_sum = {}
    @store.users.each do |user|
      if user.submission
        @working_time_sum.store(user.id, 0)
      end
    end
  end

  def edit
    @store = current_user.store
    @shifts = Shift.where(date: params[:date], working_time_from: params[:working_time_from])
    available_staff = calendar
    @date_available_staff = available_staff.find { |a| a[:date] == params[:date].to_date && a[:working_time_from].strftime( "%H:%M" ) == params[:working_time_from] }
    @submission_user = []
    @store_user = []
    Store.find(params[:store_id]).users.each do |user|
      @store_user.push(user)
      if user.submission
        @submission_user.push(user)
      end
    end
  end

  def destroy
    @store = current_user.store
    @shift = Shift.find(params[:id])
    @shift.destroy
    redirect_to "/stores/#{@store.id}/shifts/#{@shift.date}/#{@shift.working_time_from.strftime( "%H:%M" )}/edit"
  end

  def create
    @store = current_user.store
    @shift = Shift.new(
      store_id: @store.id,
      date: params[:date],
      working_time_from: params[:working_time_from],
      working_time_to: params[:working_time_to],
      user_id: params[:user_id]
    )
    @shift.save
    redirect_to "/stores/#{@store.id}/shifts/#{@shift.date}/#{@shift.working_time_from.strftime( "%H:%M" )}/edit"
  end
end
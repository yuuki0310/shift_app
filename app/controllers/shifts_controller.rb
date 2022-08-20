class ShiftsController < ApplicationController

  helper_method :date_table, :store_date_table, :calendar
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

  def calendar
    available_staff = []
    store_working_time_sum = 0
    date_range = Date.parse('2022-08-01').to_date..Date.parse('2022-09-01').to_date - 1
    date_range.each do |date|
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
    working_time_sum = {}
    store.users.each do |user|
      if user.submission
        working_time_ratio.store(user.id, store_working_time_sum * (user.working_desired_time.to_f / working_desired_time_sum.to_f))
        working_time_sum.store(user.id, 0)
      end
    end
    available_staff.each do |as|
      working_time_ratio.sort_by { |k, v| -v }.to_h.each do |id, ratio|
        if as[:working_staff].size < as[:count] && as[:ids].include?(id)
          as[:working_staff].push(id)
          working_time_ratio[id] -= (as[:working_time_to] - as[:working_time_from]) / 60
          working_time_sum[id] += (as[:working_time_to] - as[:working_time_from]) / 60
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
          Shift.create(as.reject { |k,v| k == :count || k == :ids || k == :working_staff }.merge(store_id: @current_user.store.id, user_id: ws))
        end
      end
    end 

    return available_staff, working_time_sum
  end

  def index
    @store = @current_user.store
  end

  def edit
    date = Shift.find(params[:id]).date
    working_time_from = Shift.find(params[:id]).working_time_from
    @shifts = Shift.where(date: date, working_time_from: working_time_from)
    available_staff, working_time_sum = calendar
    @date_available_staff = available_staff.find { |a| a[:date] == date && a[:working_time_from] == working_time_from }
    @submission_user = []
    @store_user = []
    Store.find(params[:store_id]).users.each do |user|
      @store_user.push(user)
      if user.submission
        @submission_user.push(user)
      end
    end
  end
end

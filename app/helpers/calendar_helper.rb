module CalendarHelper
  def duplicate(a, b)
    a.working_time_from <= b.working_time_from && b.working_time_from < a.working_time_to || \
    a.working_time_from < b.working_time_to && b.working_time_to <= a.working_time_to || \
    a.working_time_from == b.working_time_from && a.working_time_to == b.working_time_to
  end
  
  def calendar_wday(date)
    if date.wday == 0
      return 7
    else
      return date.wday
    end
  end

  def date_working_times(date)
    if params[:user_id]
      store = User.find(params[:user_id]).store
    elsif params[:store_id]
      store = Store.find(params[:store_id])
    end
    date_working_times = []
    month_schedules = StoreMonthSchedule.where(date: date, store_id: store.id)
    weekly_schedules = StoreWeeklySchedule.where(weeklyday_id: calendar_wday(date), store_id: store.id)    
    weekly_schedules.each do |wekkly_schedule|
      date_working_times.push(wekkly_schedule)
    end
    if month_schedules.present?
      month_schedules.each do |month_schedule|
        date_working_times.push(month_schedule)
        weekly_schedules.each do |wekkly_schedule|
          if duplicate(wekkly_schedule, month_schedule)
            date_working_times.delete(wekkly_schedule)
          end
        end
      end
    end
    date_working_times.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return date_working_times
  end
  
  def store_date_table(date)
    store_date_tables = {}
    date_working_times(date).each do |date_working_time|
      store_date_tables.store(date_working_time.working_time_from, [])
    end
    store.users.each do |user|
      if user.submission
        user_weekly_schedules = UserWeeklySchedule.where(weeklyday_id: calendar_wday(date), user_id: user.id)
        user_unable_schedules = UserUnableSchedule.where(date: date, user_id: user.id)
        date_working_times(date).each do |date_table|
          user_weekly_schedules.each do |user_schedule|
            if duplicate(user_schedule, date_table)
              store_date_tables[date_table.working_time_from].push(user.id)
            end
          end
          if user_unable_schedules
            user_unable_schedules.each do |user_unable_schedule|
              if duplicate(user_unable_schedule, date_table)
                store_date_tables[date_table.working_time_from].delete(user.id)
              end
            end
          end
        end
      end
    end
    return store_date_tables
  end

  def user_date_table
  end
  
  def available_staff_set
    available_staff = []
    store_working_time_sum = 0
    @beginning = Date.parse('2022-08-01').to_date
    ending = @beginning.next_month - 1
    @beginning..ending.each do |date|
      date_working_times(date).each do |dt|
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
    store.users.each do |user|
      if user.submission
        working_time_ratio.store(user.id, store_working_time_sum * (user.working_desired_time.to_f / working_desired_time_sum.to_f))
      end
    end
    available_staff.each do |as|
      working_time_ratio.sort_by { |k, v| -v }.to_h.each do |id, ratio|
        if as[:working_staff].size < as[:count] && as[:ids].include?(id)
          as[:working_staff].push(id)
          working_time_ratio[id] -= (as[:working_time_to] - as[:working_time_from]) / 60
        end
      end
    end
    available_staff.sort! do |a, b|
      [a[:date], a[:working_time_from]] <=> [b[:date], b[:working_time_from]]
    end
  
    unless Shift.find_by(date: @beginning..ending)
      available_staff.each do |as|
        as[:working_staff].each do |ws|
          Shift.create(as.reject { |k,v| k == :count || k == :ids || k == :working_staff }.merge(store_id: current_user.store.id, user_id: ws))
        end
      end
    end 
  
    return available_staff
  end

  def weekly_scheduled(weekly_schedules)
    @working_times = []
    weekly_schedules.each do |user_schedule|
      @working_times.push(user_schedule.working_time_from)
      @working_times.push(user_schedule.working_time_to)
    end
    if @working_times.count > 2
      @working_times.uniq!
      @working_times.sort!
    end
  end

  def bar_line?(weeklyday, working_time, weekly_schedules)
    # user_weekly_schedules = weekly_schedules.where(weeklyday_id: weeklyday, user_id: params[:user_id])
    weekly_schedules.each do |user_schedule|
      if user_schedule.working_time_from < working_time && working_time < user_schedule.working_time_to
        return true
        break
      end
    end
    return false
  end

end
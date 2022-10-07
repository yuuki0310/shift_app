module CalendarHelper
  def duplicate?(a, b)
    a.working_time_from <= b.working_time_from && b.working_time_from < a.working_time_to || \
    a.working_time_from < b.working_time_to && b.working_time_to <= a.working_time_to || \
    a.working_time_from == b.working_time_from && a.working_time_to == b.working_time_to
  end

  def subset?(a, b)
    a.working_time_from <= b.working_time_from && b.working_time_from < a.working_time_to && \
    a.working_time_from < b.working_time_to && b.working_time_from <= a.working_time_to || \
    a.working_time_from == b.working_time_from && b.working_time_to == a.working_time_to
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
          if duplicate?(wekkly_schedule, month_schedule)
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

  def user_available_working_times(date, user_id)
    user_available_working_times = []
    user_weekly_schedules = UserWeeklySchedule.where(user_id: user_id, weeklyday_id: calendar_wday(date))
    user_unable_schedules = UserUnableSchedule.where( user_id: user_id, date: date)
    if user_weekly_schedules.empty?
      return []
    end
    date_working_times(date).each do |date_working_time|
      user_weekly_schedules.each do |user_weekly_schedule|
        if subset?(user_weekly_schedule, date_working_time)
          user_available_working_times.push(date_working_time)
        end
      end
      user_unable_schedules.each do |user_unable_schedule|
        if duplicate?(date_working_time, user_unable_schedule)
          user_available_working_times.delete(date_working_time)
        end
      end
    end
    return user_available_working_times
  end

  def store_date_available_staffs(date)
    store_date_available_staffs = []
    store_time_available_staffs = {}
    store = Store.find(params[:store_id])
    date_working_times(date).each do |date_working_time|
      store_time_available_staffs = {date: date, working_time_from: date_working_time.working_time_from, working_time_to: date_working_time.working_time_to, count: date_working_time.count, user_ids: [], working_staff: []}
      store.users.each do |user|
        user_available_working_times(date, user.id).each do |user_available_working_time|
          if user_available_working_time.working_time_from == date_working_time.working_time_from
            store_time_available_staffs[:user_ids].push(user.id)
          end
        end
      end
      store_date_available_staffs.push(store_time_available_staffs)
    end
    return store_date_available_staffs
  end

  def shift_auto_allocation
    available_staff = []
    store = Store.find(params[:store_id])
    store_working_time_sum = 0
    shift_section = ShiftSection.find_by(beginning: params[:beginning])
    (shift_section.beginning..shift_section.ending).each do |date|
      store_date_available_staffs(date).each do |store_time_available_staffs|
        available_staff.push(store_time_available_staffs)
      end
      date_working_times(date).each do |date_working_time|
        store_working_time_sum += (date_working_time.working_time_to - date_working_time.working_time_from) * date_working_time.count / 60
      end
    end
    
    available_staff.sort! do |a, b|
      (b[:count].to_f / b[:user_ids].size.to_f) <=> (a[:count].to_f / a[:user_ids].size.to_f)
    end
    working_desired_time_sum = 0
    store.users.each do |user|
      if user.user_submissions.find_by(shift_section_id: shift_section.id)
        working_desired_time_sum += user.working_desired_time
      end
    end
    working_time_ratio  = {}
    store.users.each do |user|
      if user.user_submissions.find_by(shift_section_id: shift_section.id)
        working_time_ratio.store(user.id, store_working_time_sum * (user.working_desired_time.to_f / working_desired_time_sum.to_f))
      end
    end
    available_staff.each do |as|
      working_time_ratio.sort_by { |k, v| -v }.to_h.each do |id, ratio|
        if as[:working_staff].size < as[:count] && as[:user_ids].include?(id)
          as[:working_staff].push(id)
          working_time_ratio[id] -= (as[:working_time_to] - as[:working_time_from]) / 60
        end
      end
    end
    available_staff.sort! do |a, b|
      [a[:date], a[:working_time_from]] <=> [b[:date], b[:working_time_from]]
    end
  
    available_staff.each do |as|
      as[:working_staff].each do |ws|
        Shift.create(as.reject { |k,v| k == :count || k == :user_ids || k == :working_staff }.merge(store_id: current_user.store.id, user_id: ws))
      end
    end

    # return available_staff
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
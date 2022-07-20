class ShiftsController < ApplicationController

  helper_method :date_table, :store_date_table

  def date_table(date)
    def calendar_wday(date)
      if date.wday == 0
        return 7
      else
        return date.wday
      end
    end
    $date_tables = []
    date_schedules = StoreMonthSchedule.where(date: date, store_id: params[:store_id])
    weekly_schedules = StoreSchedule.where(weeklyday_id: calendar_wday(date), store_id: params[:store_id])    
    weekly_schedules.each do |wekkly_schedule|
      $date_tables.push(wekkly_schedule)
    end
    if date_schedules.present?
      date_schedules.each do |date_schedule|
        $date_tables.push(date_schedule)
        weekly_schedules.each do |wekkly_schedule|
          if wekkly_schedule.working_time_from < date_schedule.working_time_from && date_schedule.working_time_from < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from < date_schedule.working_time_to && date_schedule.working_time_to < wekkly_schedule.working_time_to || \
            wekkly_schedule.working_time_from == date_schedule.working_time_from && wekkly_schedule.working_time_to == date_schedule.working_time_to
            $date_tables.delete(wekkly_schedule)
          end
        end
      end
    end
    $date_tables.sort! do |a, b|
      a[:working_time_from].to_time <=> b[:working_time_from].to_time
    end
    return $date_tables
  end


  
  def store_date_table(date)
    store_date_tables = {}
    store = Store.find(params[:store_id])
    store.users.each do |user|
      if user.submission
        store_date_tables.store(user.id, date_table(date))
      end
      user_schedules = UserSchedule.where(weeklyday_id: calendar_wday(date), user_id: user.id)
      $date_tables.each do |date_table|
        user_schedules.each do |user_schedule|
          unless user_schedule.working_time_from < date_table.working_time_from && date_table.working_time_from < user_schedule.working_time_to || \
            user_schedule.working_time_from < date_table.working_time_to && date_table.working_time_to < user_schedule.working_time_to || \
            user_schedule.working_time_from == date_table.working_time_from && date_table.working_time_to == user_schedule.working_time_to then
            store_date_tables[user.id].delete(date_table)
          end
        end
      end
      user_unable_schedules = UserUnableSchedule.where(date: date, user_id: user.id)
      if user_unable_schedules
        user_unable_schedules.each do |user_unable_schedule|
          $date_tables.each do |date_table|
            if date_table.working_time_from < user_unable_schedule.working_time_from && user_unable_schedule.working_time_from < date_table.working_time_to || \
              date_table.working_time_from < user_unable_schedule.working_time_to && user_unable_schedule.working_time_to < date_table.working_time_to || \
              date_table.working_time_from == user_unable_schedule.working_time_from && date_table.working_time_to == user_unable_schedule.working_time_to
              store_date_tables[user.id].delete(date_table)
            end
          end
        end
      end
      # store_date_tables[user.id].sort! do |a, b|
      #   a[:working_time_from].to_time <=> b[:working_time_from].to_time
      # end
    end
    return store_date_tables
  end

  def index
  end
end

class StoreSchedule < ApplicationRecord
  belongs_to :store
  # belongs_to :Weeklyday

  validates :store_id, :weeklyday_id, :working_time_from, :working_time_to, :count, presence: true
  validate :working_time, :duplicate

  def working_time
    if working_time_from > working_time_to
      errors.add(:working_time_from, "可能な時間に設定してください")
    end
  end
end

def duplicate
  store_schedule_weeklydays = @current_user.store.store_schedules.where(weeklyday_id: weeklyday_id)
  store_schedule_weeklydays.each do |store_schedule_weeklyday|
    def decision
      store_schedule.working_time_from < working_time_from && working_time_from < store_schedule.working_time_to ||
      store_schedule.working_time_from < working_time_to && working_time_to < store_schedule.working_time_to
    end
    if decision
      errors.add(:weeklyday_id, "重複しています")
    end
  end
end

class StoreSchedule < ApplicationRecord
  belongs_to :store
  # belongs_to :Weeklyday

  with_options presence: true do
    validates :store_id
    validates :weeklyday_id
    validates :working_time_from
    validates :working_time_to
    validates :count
  end
  validate :working_time, :duplicate

  def working_time
    if working_time_from && working_time_to
      if working_time_from > working_time_to
        errors.add(:working_time_from, "可能な時間に設定してください")
      end
    end
  end

  def duplicate
    current_user_store = Store.find_by(id: store_id)
    store_schedule_weeklydays = current_user_store.store_schedules.where(weeklyday_id: weeklyday_id)
    store_schedule_weeklydays.each do |store_schedule_weeklyday|
      if store_schedule_weeklyday.working_time_from < working_time_from && working_time_from < store_schedule_weeklyday.working_time_to || \
        store_schedule_weeklyday.working_time_from < working_time_to && working_time_to < store_schedule_weeklyday.working_time_to
        errors.add(:weeklyday_id, "重複しています。可能な時間を設定するか、スケジュールを削除してからもう一度登録してください。")
      end
    end
  end
end


class StoreMonthSchedule < ApplicationRecord
  belongs_to :store

  with_options presence: true do
    validates :store_id
    validates :date
    validates :working_time_from
    validates :working_time_to
    validates :count
  end
  validates :working_time_from, uniqueness: {scope: [:working_time_to, :working_time_from, :store_id, :date]}
  validates :working_time_to, uniqueness: {scope: [:working_time_from, :working_time_from, :store_id, :date]}
  validate :working_time, :duplicate

  def working_time
    if working_time_from && working_time_to
      if working_time_from >= working_time_to
        errors.add(:working_time_from, "可能な時間に設定してください")
      end
    end
  end

  def duplicate
    if working_time_from && working_time_to
      current_user_store = Store.find_by(id: store_id)
      store_schedule_dates = current_user_store.store_month_schedules.where(date: date)
      if store_schedule_dates
        store_schedule_dates.each do |store_schedule_date|
          if store_schedule_date.working_time_from < working_time_from && working_time_from < store_schedule_date.working_time_to || \
            store_schedule_date.working_time_from < working_time_to && working_time_to < store_schedule_date.working_time_to
            errors.add(:date, "重複しています。可能な時間を設定するか、スケジュールを削除してからもう一度登録してください。")
          end
        end
      end
    end
  end
end

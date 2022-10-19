class StoreMonthSchedule < ApplicationRecord
  include CalendarHelper
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
  validate :working_time, :shift_section, :duplicate

  def working_time
    if working_time_from && working_time_to
      if working_time_from >= working_time_to
        errors.add(:working_time_from, "可能な時間に設定してください")
      end
    end
  end

  def shift_section
    if working_time_from && working_time_to
      shift_sections = ShiftSection.where(store_id: store_id, status: 0)
      shift_section = shift_sections.find {|shift_section| date.between?(shift_section.beginning, shift_section.ending)}
      if shift_section.nil?
        errors.add(:date, "期間内の日付を設定してください。")
      end
    end
  end

  def duplicate
    if working_time_from && working_time_to
      current_user_store = Store.find_by(id: store_id)
      store_schedule_dates = current_user_store.store_month_schedules.where(date: date)
      store_schedule_dates&.each do |store_schedule_date|
        if for_model_duplicate?(store_schedule_date)
          errors.add(:date, "重複しています。可能な時間を設定するか、スケジュールを削除してからもう一度登録してください。")
        end
      end
    end
  end
end

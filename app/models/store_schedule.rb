class StoreSchedule < ApplicationRecord
  belongs_to :store
  # belongs_to :Weeklyday

  validates :store_id, :weeklyday_id, :working_time_from, :working_time_to, :count, presence: true
  validate :working_time

  def working_time
    if working_time_from > working_time_to
      errors.add(:working_time_from, "可能な時間に設定してください")
    end
  end
end

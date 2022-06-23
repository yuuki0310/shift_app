class StoreSchedule < ApplicationRecord
  belongs_to :store
  # belongs_to :Weeklyday

  # validates :store_id, :weeklyday_id, :working_time_from, :working_time_to, :count, presence: true
end

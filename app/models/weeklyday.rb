class Weeklyday < ApplicationRecord
  has_many :store_weekly_schedules
  # has_many :stores, through: :store_weekly_schedules
  has_many :user_weekly_schedules

end

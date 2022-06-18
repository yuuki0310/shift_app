class Weeklyday < ApplicationRecord
  has_many :store_schedules
  # has_many :stores, through: :store_schedules
end

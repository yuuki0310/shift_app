class Weeklyday < ApplicationRecord
  has_many :store_schedules, dependent: :destroy
  has_many :stores, through: :store_schedules
end

class Weeklyday < ApplicationRecord
  has_many :stores, through: :store_schedules
  has_many :store_schedules, dependent: :destroy
end

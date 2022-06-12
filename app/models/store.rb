class Store < ApplicationRecord
  has_many :Weeklydays, through: :store_schedules
  has_many :store_schedules, dependent: :destroy
end

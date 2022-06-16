class Store < ApplicationRecord
  has_many :store_schedules, dependent: :destroy
  has_many :Weeklydays, through: :store_schedules
  has_many :users
  accepts_nested_attributes_for :store_schedules
end

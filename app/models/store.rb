class Store < ApplicationRecord
  has_many :store_schedules, dependent: :destroy
  has_many :Weeklydays, through: :store_schedules
  has_many :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :store_month_schedules
  has_many :store_shift_submissions
end

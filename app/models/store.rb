class Store < ApplicationRecord
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new

  has_many :store_weekly_schedules, dependent: :destroy
  has_many :Weeklydays, through: :store_weekly_schedules
  has_many :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :store_month_schedules
  has_many :shift_sections, dependent: :destroy
end

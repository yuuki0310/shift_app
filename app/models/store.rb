class Store < ApplicationRecord
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new

  has_many :store_schedules, dependent: :destroy
  has_many :Weeklydays, through: :store_schedules
  has_many :users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :store_month_schedules
  has_many :store_shift_submissions
  # has_one :affiliation_application

  def to_param
    public_uid
  end
end

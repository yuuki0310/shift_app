class User < ApplicationRecord
  has_secure_password
  belongs_to :store
  has_many :user_schedules
  has_many :user_unable_schedules
  has_many :submissions
end

class User < ApplicationRecord
  belongs_to :store
  has_many :user_schedules
  has_many :user_unable_schedules
  has_one :submission
end

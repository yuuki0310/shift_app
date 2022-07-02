class User < ApplicationRecord
  belongs_to :store
  has_many :user_schedules
end

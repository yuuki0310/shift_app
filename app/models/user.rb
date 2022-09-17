class User < ApplicationRecord
  has_secure_password
  belongs_to :store
  has_many :user_schedules
  has_many :user_unable_schedules
  has_many :submissions

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true}
end

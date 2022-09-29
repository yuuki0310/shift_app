class User < ApplicationRecord
  has_secure_password

  belongs_to :store, optional: true
  has_many :user_weekly_schedules
  has_many :user_unable_schedules
  has_many :user_submissions
  has_one :affiliation_application

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true}

  VALID_PASSWORD_REGEX =/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX, message: "は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります"}, on: :create

end

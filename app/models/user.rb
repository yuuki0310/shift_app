class User < ApplicationRecord
  generate_public_uid
  # generate_public_uid generator: PublicUid::Generators::NumberRandom.new
  # generate_public_uid generator: PublicUid::Generators::HexStringSecureRandom.new(6)
  has_secure_password

  belongs_to :store
  has_many :user_schedules
  has_many :user_unable_schedules
  has_many :submissions

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true}

  VALID_PASSWORD_REGEX =/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX, message: "は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります"}

end

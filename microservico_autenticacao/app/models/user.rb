class User < ApplicationRecord
  has_secure_password

  has_many :access_tokens, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  before_save { self.email = email.downcase }
end

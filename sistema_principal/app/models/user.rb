class User < ApplicationRecord
  # Habilita autenticação segura
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
  validates :external_auth_id, presence: true, uniqueness: true
end

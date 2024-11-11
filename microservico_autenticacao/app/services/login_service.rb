require 'dry/monads'
require 'dry/monads/do'
require 'dry/initializer'

class LoginService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  option :email
  option :password
  option :user, default: -> { User.find_by(email: email) }

  def call
    user = yield find_user
    yield authenticate_user(user)
    token = yield generate_access_token(user)

    Success(token: token, user: user)
  end

  private

  def find_user
    user ? Success(user) : Failure(:user_not_found)
  end

  def authenticate_user(user)
    user.authenticate(password) ? Success(user) : Failure(:invalid_credentials)
  end

  def generate_access_token(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    token   = JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
    Success(token)
  end
end

require 'dry/monads'
require 'dry/monads/do'
require 'dry/initializer'

class TokenValidationService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  option :headers
  option :secret_key, default: -> { Rails.application.secret_key_base }

  def call
    token         = yield extract_token
    decoded_token = yield decode_token(token)
    user          = yield find_user(decoded_token)

    Success(user)
  end

  private

  def extract_token
    authorization_header = headers['Authorization']
    if authorization_header.present? && authorization_header.start_with?('Bearer ')
      Success(authorization_header.split(' ').last)
    else
      Failure(:missing_or_invalid_token)
    end
  end

  def decode_token(token)
    payload = JWT.decode(token, secret_key, true, algorithm: 'HS256')[0]
    Success(payload.with_indifferent_access)
  rescue JWT::DecodeError
    Failure(:invalid_token)
  end

  def find_user(payload)
    user = User.find_by(id: payload[:user_id])
    user ? Success(user) : Failure(:user_not_found)
  end
end

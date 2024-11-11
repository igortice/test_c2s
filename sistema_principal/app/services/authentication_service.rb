require 'dry/monads'
require 'dry/monads/do'
require 'dry/initializer'

class AuthenticationService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  option :api_client, default: -> { Faraday.new }
  option :auth_url, default: -> { Rails.configuration.x.microservice_autenticacao_url }

  def login(email:, password:)
    response  = yield send_login_request(email, password)
    auth_data = yield parse_response(response)
    user      = yield find_or_create_user(auth_data)

    Success(user)
  end

  def validate_token(token:)
    response = @api_client.post("#{@auth_url}/api/v1/validate_token") do |req|
      req.headers['Authorization'] = "Bearer #{token}"
    end

    response.success? ? Success(response.body) : Failure(:invalid_token)
  end

  private

  def send_login_request(email, password)
    response = api_client.post("#{Rails.configuration.x.microservice_autenticacao_url}/api/v1/login") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body                    = { email: email, password: password }.to_json
    end

    response.success? ? Success(response) : Failure(:invalid_credentials)
  rescue Faraday::ConnectionFailed => e
    Failure({ error: :connection_error, details: e.message })
  end

  def parse_response(response)
    auth_data = JSON.parse(response.body, symbolize_names: true)
    auth_data[:user] ? Success(auth_data) : Failure(:invalid_response)
  rescue JSON::ParserError
    Failure(:invalid_json)
  end

  def find_or_create_user(auth_data)
    user_info = auth_data[:user]
    token     = auth_data[:token]
    user      = User.find_or_create_by!(external_auth_id: user_info[:id]) do |u|
      u.name  = user_info[:name]
      u.email = user_info[:email]
    end
    Success(token: token, user: user)
  rescue ActiveRecord::RecordInvalid => e
    Failure(e.message)
  end
end

require 'dry/monads'
require 'dry/monads/do'
require 'dry/initializer'

class UserCreationService
  extend Dry::Initializer
  include Dry::Monads[:result, :do]

  option :user_params
  option :auth_service_url, default: -> { Rails.configuration.x.microservice_autenticacao_url }

  def call
    microservice_user = yield create_user_in_microservice
    local_user        = yield create_user_locally(microservice_user)

    Success(local_user)
  end

  private

  def create_user_in_microservice
    response = Faraday.post("#{auth_service_url}/api/v1/users") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body                    = { user: user_params }.to_json
    end

    if response.success?
      user_data = JSON.parse(response.body).dig('user') || {}
      Success(user_data.with_indifferent_access)
    else
      error_details = JSON.parse(response.body)['errors'] rescue 'Unknown error'
      Failure({ error: :microservice_error, details: error_details })
    end
  rescue Faraday::ConnectionFailed => e
    Failure({ error: :connection_error, details: e.message })
  end

  def create_user_locally(microservice_user)
    Rails.logger.info("Creating user locally: #{microservice_user}")
    user = User.new(
      name:             microservice_user[:name],
      email:            microservice_user[:email],
      password:         user_params[:password],
      external_auth_id: microservice_user[:id]
    )

    user.save ? Success(user) : Failure(user.errors.full_messages)
  end
end

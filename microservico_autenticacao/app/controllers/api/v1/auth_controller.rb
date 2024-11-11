class Api::V1::AuthController < ApplicationController
  rescue_from StandardError, with: :handle_internal_error

  def login
    result = LoginService.new(
      email: login_params[:email],
      password: login_params[:password]
    ).call

    if result.success?
      render json: { token: result.value![:token], user: result.value![:user] }, status: :ok
    else
      render json: { error: result.failure }, status: :unauthorized
    end
  rescue => e
    handle_error(e)
  end

  def validate_token
    result = TokenValidationService.new(headers: request.headers).call

    if result.success?
      render json: { message: 'Token válido', user_id: result.value!.id }, status: :ok
    else
      render json: { error: result.failure }, status: :unauthorized
    end

  rescue => e
    handle_error(e)
  end

  # def refresh_token
  #   refresh_token = params[:refresh_token]
  #   result        = RefreshTokenService.new.call(refresh_token)
  #
  #   if result.success?
  #     render json: { token: result.value! }, status: :ok
  #   else
  #     render json: { error: result.failure }, status: :unauthorized
  #   end
  # end
  #
  # def logout
  #   # Implementação opcional para invalidar tokens.
  #   render json: { message: 'Logout realizado com sucesso' }, status: :ok
  # end

  private

  def login_params
    params.require(:auth).permit(:email, :password)
  end

  def handle_error(error)
    Rails.logger.error("Error: #{error.message}")
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end

  def handle_internal_error(error)
    Rails.logger.error("Internal Error: #{error.message}")
    render json: { error: 'Something went wrong' }, status: :internal_server_error
  end
end

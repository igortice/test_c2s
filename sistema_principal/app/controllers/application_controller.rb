class ApplicationController < ActionController::Base
  # Permite apenas navegadores modernos que suportam imagens webp, push web, badges, import maps, CSS nesting e CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  before_action :validate_token_by_time

  # Método para obter o usuário atual com base na sessão
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Método para obter o token de acesso da sessão
  def get_access_token
    session[:access_token]
  end

  # Filtro para autenticar o usuário antes de acessar certas ações
  def authenticate_user!
    redirect_to auth_login_form_path, alert: "Faça login para continuar" if current_user.nil?
  end

  # Valida o token de acesso pelo tempo definido
  def validate_token_by_time
    return unless current_user # Executa apenas se houver um usuário logado

    if session[:token_expiry].present? && Time.current <= session[:token_expiry]
      # Token ainda é válido pelo tempo definido, não chama o serviço
      return
    end

    token = session[:access_token]
    if token.blank?
      handle_session_expiration
      return
    end

    result = AuthenticationService.new.validate_token(token: token)
    if result.success?
      session[:token_expiry] = Time.current + 1.minutes
    else
      handle_session_expiration
    end
  end

  # Reseta a sessão do login
  def reset_session_login
    session[:access_token] = nil
    session[:user_id]      = nil
    session[:token_expiry] = nil
  end

  private

  # Método para lidar com a expiração da sessão
  def handle_session_expiration
    reset_session
    redirect_to auth_login_form_path, alert: "Sessão expirada, faça login novamente."
  end
end

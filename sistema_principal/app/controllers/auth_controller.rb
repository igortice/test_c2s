# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  def new
    @user = User.new
  end

  def create
    result = UserCreationService.new(user_params: user_params.to_h).call

    if result.success?
      redirect_to auth_login_form_path, notice: "Conta criada com sucesso! Faça login para continuar."
    else
      flash.now[:alert] = result.failure
      @user             = User.new(user_params)
      render :new
    end
  end

  def login_form
  end

  def login
    result = AuthenticationService.new.login(email: params[:email], password: params[:password])

    if result.success?
      session[:access_token]      = result.value![:token]
      session[:user_id]           = result.value![:user][:id]
      cookies.encrypted[:user_id] = { value: session[:user_id], httponly: true }
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid credentials"
      render :login_form
    end
  end

  def logout
    reset_session_login

    redirect_to root_path, notice: "Você saiu da sua conta."
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

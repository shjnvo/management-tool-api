class V1::SessionsController < ApplicationController
  skip_before_action :require_user, only: :create

  def create
    if user = user_authenticaton!
      token = JwtService.encode({ user_token: user&.generate_token! })
      user.token = token
      render json: {message: I18n.t('responce_message.login_success'), user: user}, status: :ok
    else
      render json: {message: I18n.t('responce_message.uncorrect')}, status: :unauthorized
    end
  end

  def destroy
    current_user&.reset_token!
    render json: {message: I18n.t('responce_message.logout_success')}, status: :ok
  end

  private

  def login_params
    params.permit(:email)
  end

  def user_authenticaton!
    user = User.unlockeds.find_by(email: login_params[:email])
    return user if user
  end
end

# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_inactive_user,only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  def after_sign_in_path_for(resource)
    post_images_path
  end

  # 退会している場合の処理
  def reject_inactive_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && !@user.user_status
        redirect_to new_user_session_path
      end
    end
  end

  # ゲストログイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'guestuserでログインしました。'
  end

end

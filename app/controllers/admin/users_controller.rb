class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

 private

  def user_params
    params.require(:customer).permit(:family_name, :first_name, :kana_family_name, :kana_first_name, :postal_code, :address, :phone_number, :email, :customer_status)
  end
  
end

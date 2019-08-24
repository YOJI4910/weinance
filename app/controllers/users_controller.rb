class UsersController < ApplicationController
  before_action :login_required, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to @user, notice:"ユーザー「#{@user.name}」を行いました。"
    else
      render :new
    end
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
      redirect_to user_url(@user), notice:"ユーザー「#{@user.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url, notice:"ユーザー「#{@user.name}」を削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :height, :password, :password_confirmation)
  end
end

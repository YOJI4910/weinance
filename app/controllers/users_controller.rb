class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :show]

  def show
    @user = User.find(params[:id])
    @records = @user.records.order(created_at: :desc)
    @followers = @user.followers
  end
end

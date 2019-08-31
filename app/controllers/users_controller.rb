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
      # 登録と同時にログイン
      session[:user_id] = @user.id
      redirect_to root_url, notice:"ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    # 1ヶ月分のrecordのcreated_atをリストで取得
    # record_last30 = @user.records.where('created_at >= ?', 1.month.ago)
    # 同じ記録日のレコードは平均値の１つのデータとする
    # "10/04" : [10,20],
    record_last30 = @user.records.where('created_at >= ?', 1.month.ago).order(:created_at).group_by{ |p| p.created_at.strftime('%m/%d') }.map {|k,v| [k, v.map(&:weight)]}.to_h 
    # 複数値をもつ配列を平均する
    # "10/04" : 15
    average_last30 = record_last30.map { |key, value| [key, value.sum/value.length]}.to_h

    @labels = average_last30.keys
    @datas = average_last30.values
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
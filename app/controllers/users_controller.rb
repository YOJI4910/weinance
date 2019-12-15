class UsersController < ApplicationController  
  before_action :login_required, only: [:edit, :update, :destroy]

  def index
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
    record_last30 = @user.records.where('created_at >= ?', 1.month.ago). # 1ヶ月分のrecordを取得
                          order(:created_at).
                          group_by{ |p| p.created_at.strftime('%m/%d') }. # 同日複数レコードをくくる（ハッシュ） "10/04" => [some Records]
                          to_h {|k,v| [k, v.map(&:weight).sum / v.count]}               # レコードから体重を抽出  "10/04" => 体重の平均値
    @labels = record_last30.keys
    @datas = record_last30.values
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
    params.require(:user).permit(:name, :email, :height, :password, :password_confirmation, :image)
  end
end

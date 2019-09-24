class UsersController < ApplicationController  
  include Pagy::Backend
  before_action :login_required, only: [:edit, :update, :destroy]

  def index
    # recordテーブルから重複を省く。}{user_id => latest_record_date}
    user_hash = Record.group(:user_id).maximum(:created_at)

    # 順のリスト[[user_id, created_at], [k, v], [k, v], ...] vの値で降順
    ids = user_hash.sort_by{ |k, v| v }.reverse.to_h.keys
    @pagy_all, @users = pagy(User.where(id: ids).order("field(id, #{ids.join(',')})"), page_param: :page_all)

    # ======================favo用
    # current_userのfollowingリスト
    follow_list = current_user.active_relationships.pluck(:follower_id)
    favo_hash = Record.where(user_id: follow_list).group(:user_id).maximum(:created_at)
    f_ids = favo_hash.sort_by{ |k, v| v }.reverse.to_h.keys
    @pagy_fav, @favos = pagy(User.where(id: f_ids).order("field(id, #{f_ids.join(',')})"), page_param: :page_fav)
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
    params.require(:user).permit(:name, :email, :height, :password, :password_confirmation, :image)
  end
end
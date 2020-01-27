class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :show]

  def show
    @user = User.find(params[:id])
    records = @user.records
    @records = @user.records.order(created_at: :desc)
    record_last30 = records.
      where('created_at >= ?', 1.month.ago).
      order(:created_at).
      # 同日複数レコードをくくる（ハッシュ） "10/04" => [some Records]
      group_by { |p| p.created_at.strftime('%m/%d') }.
      # レコードから体重を抽出  "10/04" => 体重の平均値
      to_h { |k, v| [k, v.map(&:weight).sum / v.count] }
    @labels = record_last30.keys
    @datas = record_last30.values
    @followers = @user.followers
  end
end

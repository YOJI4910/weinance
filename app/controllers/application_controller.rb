class ApplicationController < ActionController::Base
  # sessionからログインユーザーを取得する操作をapplication_controllerに書くことですべてのcontrollerから呼び出せる
  # ヘルパーにすることですべてのviewからも呼び出せる
  helper_method :current_user
  helper_method :change
  helper_method :bmi
  helper_method :max_weight
  helper_method :min_weight
  helper_method :lastest_weight

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end

  def change(user)
    last_data = user.records.where(created_at: Date.today.last_month.all_month).pluck('weight')
    last_count = user.records.where(created_at: Date.today.last_month.all_month).count
    last_avg = last_data.sum / last_count
    this_data = lastest_weight(user)
    @change = ( ( this_data - last_avg ) / last_avg )*100
  rescue ZeroDivisionError
    0
  end

  def bmi(user)
    if user.records.present?
      # 身長 cm > m
      height_m = user.height / 100
      @bmi = ( lastest_weight(user) / (height_m * height_m) ).round(1)
    else
      @bmi = "-"
    end
  end

  def max_weight(user)
    # 過去30日の最高体重を返す
    pre30_data = user.records.where('created_at >= ?', 30.days.ago).pluck('weight')
    @max_weight = pre30_data.max
  end

  def min_weight(user)
    # 過去30日の最小体重を返す
    pre30_data = user.records.where('created_at >= ?', 30.days.ago).pluck('weight')
    @min_weight = pre30_data.min
  end

  def lastest_weight(user)
    user.records.order(created_at: :desc).first.weight
  end
end

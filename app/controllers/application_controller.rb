class ApplicationController < ActionController::Base
  # sessionからログインユーザーを取得する操作をapplication_controllerに書くことですべてのcontrollerから呼び出せる
  # ヘルパーにすることですべてのviewからも呼び出せる
  helper_method :current_user
  helper_method :change


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
    this_data = user.records.last.weight
    @change = ( ( this_data - last_avg ) / last_avg )*100
  end

end

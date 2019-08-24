class ApplicationController < ActionController::Base
  # sessionからログインユーザーを取得する操作をapplication_controllerに書くことですべてのcontrollerから呼び出せる
  # ヘルパーにすることですべてのviewからも呼び出せる
  helper_method :current_user

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end


end

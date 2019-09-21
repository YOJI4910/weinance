class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])

    # authenticate(): password一致でtrue, 不一致でfalse
    # &.: objectがnilだったらNoMethodError返す。
    if @user&.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to root_url, notice:"ログインしました"
    else
      flash.now[:danger] = 'メールアドレスもしくは名前が一致しません。'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice:'ログアウトしました'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end

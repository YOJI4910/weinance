class ApplicationController < ActionController::Base
  # helper_method :current_user
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  # end
  def configure_permitted_parameters
    added_attrs = %i[name email height image password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: %i[email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  # def login_required
  #   redirect_to login_url unless current_user
  # end
end

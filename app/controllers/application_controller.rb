class ApplicationController < ActionController::Base
  helper_method :guest_user
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  def guest_user
    @guest_user ||= User.find_by(email: 'guest@example.com')
  end

  def configure_permitted_parameters
    added_attrs = %i[name email height image password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end

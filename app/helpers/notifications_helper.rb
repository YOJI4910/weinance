module NotificationsHelper
  include Pagy::Frontend

  def unchecked_notifications
    if current_user.present?
      current_user.passive_notifications.where(checked: false)
    end
  end
end

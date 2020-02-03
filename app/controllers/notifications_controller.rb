class NotificationsController < ApplicationController
  include Pagy::Backend
  def index
    @pagy, @notifications = pagy(current_user.passive_notifications.order(id: "DESC"))
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end

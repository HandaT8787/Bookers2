class NotificationsController < ApplicationController

  def update
    notification = Current.user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notification.notifiable.notification_redirect_path
  end
end

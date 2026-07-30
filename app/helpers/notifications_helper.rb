module NotificationsHelper
  def notification_message(notification)
    notification.notifiable.notification_message
  end
end

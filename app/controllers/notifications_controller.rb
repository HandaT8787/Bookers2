class NotificationsController < ApplicationController

  def update
    notification = Current.user.notifications.find(params[:id])
    notification.update(read: true)

    case notification.notifiable_type
    when "Book"
      redirect_to book_path(notification.notifiable)
    else
      redirect_to user_path(notification.notifiable.user)
    end
  end
end

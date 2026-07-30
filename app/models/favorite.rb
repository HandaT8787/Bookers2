class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book, counter_cache: true
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create do
    create_notification(user_id: book.user_id)
  end

  validates :user_id, uniqueness: { scope: :book_id }

  def notification_message
    "投稿した#{book.title}が#{user.name}さんにいいねされました"
  end

  def notification_redirect_path
    Rails.application.routes.url_helpers.user_path(user)
  end
end

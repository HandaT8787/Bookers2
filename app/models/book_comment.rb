class BookComment < ApplicationRecord
  belongs_to :book, counter_cache: true
  belongs_to :user
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  after_create do
    create_notification(user: book.user) unless user == book.user
  end

  def notification_message
    "あなたの投稿「#{book.title}」に#{user.name}さんがコメントしました"
  end

  def notification_redirect_path
    Rails.application.routes.url_helpers.book_path(book)
  end
end

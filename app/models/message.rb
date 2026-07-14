class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :content, presence: true, length: { maximum: 140 }

  validate :must_be_mutual_followers, on: :create

  def self.conversation_between(user_a, user_b)
    where(sender_id: user_a.id, recipient_id: user_b.id)
      .or(where(sender_id: user_b.id, recipient_id: user_a.id))
      .order(:created_at)
  end

  private

  def must_be_mutual_followers
    return if sender.blank? || recipient.blank?

    unless sender.mutual_following?(recipient)
      errors.add(:base, "相互フォローしているユーザーにのみメッセージを送信できます")
    end
  end
end

class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :views, dependent: :destroy


  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.ranked_by_weekly_favorites
    condition = ["favorites.book_id = books.id AND favorites.created_at >= ?", 1.week.ago]
    includes(:user)
      .joins("LEFT JOIN favorites ON #{sanitize_sql_array(condition)}")
      .group("books.id")
      .select("books.*, COUNT(favorites.id) AS favorites_count_this_week")
      .order("favorites_count_this_week DESC")
  end
end

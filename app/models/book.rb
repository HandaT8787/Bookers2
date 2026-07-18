class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  belongs_to :tag, optional: true
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

  def self.search_for(keyword, method)
    case method
    when "exact"
      where(title: keyword)
    when "prefix"
      where("title LIKE ?", "#{keyword}%")
    when "suffix"
      where("title LIKE ?", "%#{keyword}")
    else
      where("title LIKE ?", "%#{keyword}%")
    end
  end
  
  def self.search_by_tag(keyword, method)
    condition = case method
                when "exact"
                  keyword
                when "prefix"
                  "#{keyword}%"
                when "suffix"
                  "%#{keyword}"
                else
                  "%#{keyword}%"
                end
    joins(:tag).where("tags.name LIKE ?",condition)
  end
end

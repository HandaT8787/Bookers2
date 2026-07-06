class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_one_attached :profile_image

  validates :name, length: { in: 2..20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6, allow_blank: true }, if: -> { new_record? || !password.nil? }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      self.save(validate: false)
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end

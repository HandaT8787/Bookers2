class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :group_users, dependent: :destroy
  has_many :members, through: :group_users, source: :user

  has_one_attached :group_image

  validates :name, presence: true

  def get_group_image(width, height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      self.save(validate: false)
    end
    group_image.variant(resize_to_limit: [width, height]).processed
  end

end

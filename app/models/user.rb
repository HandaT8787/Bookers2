class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true, length: { minimum: 2 }
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 } 

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

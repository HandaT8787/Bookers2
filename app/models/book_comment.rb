class BookComment < ApplicationRecord
  belongs_to :book, counter_cache: true
  belongs_to :user

  validates :comment, presence: true
end

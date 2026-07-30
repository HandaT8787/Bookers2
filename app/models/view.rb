class View < ApplicationRecord
  belongs_to :book, counter_cache: true
end

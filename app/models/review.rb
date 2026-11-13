class Review < ApplicationRecord
  belongs_to :reviewer
  belongs_to :airport

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :comment, presence: true
end

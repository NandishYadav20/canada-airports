class Reviewer < ApplicationRecord
  has_many :reviews, dependent: :destroy

  # Many-to-many: reviewers <-> airports through reviews
  has_many :airports, -> { distinct }, through: :reviews

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

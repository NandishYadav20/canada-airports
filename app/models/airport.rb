class Airport < ApplicationRecord
  belongs_to :province

  # Routes leaving from / arriving at this airport (one-to-many)
  has_many :departing_routes, class_name: "Route", foreign_key: "origin_airport_id", dependent: :destroy
  has_many :arriving_routes, class_name: "Route", foreign_key: "destination_airport_id", dependent: :destroy

  # Many-to-many: airports <-> airlines through routes
  has_many :airlines, -> { distinct }, through: :departing_routes

  # Many-to-many: airports <-> reviewers through reviews
  has_many :reviews, dependent: :destroy
  has_many :reviewers, -> { distinct }, through: :reviews

  validates :name, presence: true
  validates :ident, presence: true, uniqueness: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  def display_code
    iata_code.presence || ident
  end

  def type_label
    airport_type.to_s.humanize
  end

  def average_rating
    reviews.average(:rating)&.round(1)
  end
end

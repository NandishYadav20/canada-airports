class Airline < ApplicationRecord
  has_many :routes, dependent: :destroy

  # Many-to-many: airlines <-> airports through routes
  has_many :airports, -> { distinct }, through: :routes, source: :origin_airport

  validates :name, presence: true
  validates :iata_code, presence: true, length: { maximum: 3 }
end

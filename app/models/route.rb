class Route < ApplicationRecord
  belongs_to :airline
  belongs_to :origin_airport, class_name: "Airport"
  belongs_to :destination_airport, class_name: "Airport"

  validates :stops, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :destination_airport_id, uniqueness: { scope: %i[airline_id origin_airport_id] }
  validate :origin_and_destination_differ

  private

  def origin_and_destination_differ
    return unless origin_airport_id.present? && origin_airport_id == destination_airport_id

    errors.add(:destination_airport, "must be different from the origin airport")
  end
end

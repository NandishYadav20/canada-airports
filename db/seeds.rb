# Seeds the database from four open data files plus the Faker gem.
#
#   1. db/data/regions.csv  - OurAirports regions (Canadian provinces & territories)
#   2. db/data/airports.csv - OurAirports airports (Canadian subset)
#   3. db/data/airlines.dat - OpenFlights airlines
#   4. db/data/routes.dat   - OpenFlights routes
#   5. Faker                - reviewers and airport reviews
#
# Run with: rails db:seed

require "csv"

DATA_DIR = Rails.root.join("db", "data")
AIRPORT_TYPES = %w[large_airport medium_airport].freeze

# OpenFlights files use \N for empty values.
def openflights_value(value)
  value.nil? || value == "\\N" || value.strip.empty? ? nil : value.strip
end

puts "Clearing existing data..."
Review.delete_all
Reviewer.delete_all
Route.delete_all
Airline.delete_all
Airport.delete_all
Province.delete_all

# ---------------------------------------------------------------------------
# 1 & 2. Provinces and airports (OurAirports)
# ---------------------------------------------------------------------------
regions = CSV.read(DATA_DIR.join("regions.csv"), headers: true, encoding: "bom|utf-8")
             .index_by { |row| row["code"] }

airport_rows = CSV.read(DATA_DIR.join("airports.csv"), headers: true, encoding: "bom|utf-8")
                  .select { |row| row["iso_country"] == "CA" && AIRPORT_TYPES.include?(row["type"]) }
                  .reject { |row| row["name"].start_with?("(Duplicate)") }

provinces = {}
airport_rows.each do |row|
  region_code = row["iso_region"]
  region = regions[region_code]
  next if region.nil?

  province = provinces[region_code] ||= Province.find_or_create_by(code: region_code) do |p|
    p.name           = region["name"]
    p.local_code     = region["local_code"]
    p.wikipedia_link = region["wikipedia_link"]
  end
  next unless province.persisted?

  airport = province.airports.create(
    name:              row["name"],
    ident:             row["ident"],
    iata_code:         row["iata_code"].presence,
    airport_type:      row["type"],
    latitude:          row["latitude_deg"],
    longitude:         row["longitude_deg"],
    elevation_ft:      row["elevation_ft"].presence,
    municipality:      row["municipality"],
    scheduled_service: row["scheduled_service"] == "yes",
    wikipedia_link:    row["wikipedia_link"].presence
  )
  puts "Invalid airport #{row['name']}: #{airport.errors.full_messages.inspect}" unless airport.persisted?
end

puts "Created #{Province.count} provinces/territories."
puts "Created #{Airport.count} airports."

airports_by_iata = Airport.where.not(iata_code: nil).index_by(&:iata_code)

# ---------------------------------------------------------------------------
# 3 & 4. Airlines and routes (OpenFlights)
# ---------------------------------------------------------------------------
route_rows = CSV.read(DATA_DIR.join("routes.dat"), liberal_parsing: true).select do |row|
  airports_by_iata.key?(row[2]) && airports_by_iata.key?(row[4])
end
needed_airline_ids = route_rows.map { |row| row[1] }.uniq

airlines = {}
CSV.read(DATA_DIR.join("airlines.dat"), liberal_parsing: true).each do |row|
  openflights_id = row[0]
  next unless needed_airline_ids.include?(openflights_id)

  airline = Airline.create(
    name:      openflights_value(row[1]),
    iata_code: openflights_value(row[3]),
    icao_code: openflights_value(row[4]),
    callsign:  openflights_value(row[5]),
    country:   openflights_value(row[6]),
    active:    row[7] == "Y"
  )

  if airline.persisted?
    airlines[openflights_id] = airline
  else
    puts "Invalid airline #{row[1]}: #{airline.errors.full_messages.inspect}"
  end
end

puts "Created #{Airline.count} airlines."

route_rows.each do |row|
  airline = airlines[row[1]]
  next if airline.nil?

  route = airline.routes.create(
    origin_airport:      airports_by_iata[row[2]],
    destination_airport: airports_by_iata[row[4]],
    stops:               openflights_value(row[7]).to_i,
    equipment:           openflights_value(row[8])
  )
  puts "Skipped route #{row[2]}-#{row[4]}: #{route.errors.full_messages.inspect}" unless route.persisted?
end

puts "Created #{Route.count} routes."

# ---------------------------------------------------------------------------
# 5. Reviewers and reviews (Faker)
# ---------------------------------------------------------------------------
reviewed_airports = Airport.where(scheduled_service: true).to_a

50.times do
  reviewer = Reviewer.create(
    name:      Faker::Name.name,
    email:     Faker::Internet.unique.email,
    home_city: Faker::Address.city
  )
  next unless reviewer.persisted?

  reviewed_airports.sample(rand(3..8)).each do |airport|
    reviewer.reviews.create(
      airport:    airport,
      rating:     rand(1..5),
      title:      Faker::Lorem.sentence(word_count: 4),
      comment:    Faker::Lorem.paragraph(sentence_count: 3),
      visited_on: Faker::Date.between(from: 3.years.ago, to: Date.today)
    )
  end
end

puts "Created #{Reviewer.count} reviewers."
puts "Created #{Review.count} reviews."

total = Province.count + Airport.count + Airline.count + Route.count + Reviewer.count + Review.count
puts "Total rows created: #{total}"

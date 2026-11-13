# 1.1 – Dataset Description

## Topic
Canadian airports, the airlines that fly between them, and traveller reviews of each airport.

## Data sources

| # | Source | File | What it contains |
|---|--------|------|------------------|
| 1 | OurAirports (https://github.com/davidmegginson/ourairports-data) | `db/data/regions.csv` | Provinces/territories: `code` (e.g. CA-MB), `local_code` (MB), `name`, `wikipedia_link` |
| 2 | OurAirports | `db/data/airports.csv` | Airports: `ident`, `type`, `name`, `latitude_deg`, `longitude_deg`, `elevation_ft`, `iso_region`, `municipality`, `scheduled_service`, `iata_code`, `wikipedia_link` |
| 3 | OpenFlights (https://github.com/jpatokal/openflights) | `db/data/airlines.dat` | Airlines: OpenFlights ID, name, IATA, ICAO, callsign, country, active (Y/N) |
| 4 | OpenFlights | `db/data/routes.dat` | Routes: airline code, airline ID, source airport IATA, destination airport IATA, stops, equipment |
| 5 | Faker gem | generated in `db/seeds.rb` | Reviewers (name, email, home city) and reviews (rating, title, comment, visit date) |

The CSV/DAT files are the Canadian subset of the original files. The seed script imports only large and medium airports.

## Structure
- `regions.csv` and `airports.csv` are CSV files with a header row.
- `airlines.dat` and `routes.dat` are header-less CSV files; `\N` means an empty value.

## Database tables and columns
- **provinces** – name, code, local_code, wikipedia_link
- **airports** – name, ident, iata_code, airport_type, latitude, longitude, elevation_ft, municipality, scheduled_service, wikipedia_link, province_id (FK)
- **airlines** – name, iata_code, icao_code, callsign, country, active
- **routes** (join table) – airline_id (FK), origin_airport_id (FK → airports), destination_airport_id (FK → airports), stops, equipment
- **reviewers** – name, email, home_city
- **reviews** (join table) – reviewer_id (FK), airport_id (FK), rating, title, comment, visited_on

## How the datasets are related / integrated
- **Province → Airports (one-to-many):** each airport's `iso_region` (e.g. CA-MB) matches a region `code` in `regions.csv`.
- **Airlines ↔ Airports (many-to-many through routes):** OpenFlights routes use airport IATA codes, which are matched to the `iata_code` column from OurAirports. The route's airline ID is matched to the airline ID in `airlines.dat`.
- **Reviewers ↔ Airports (many-to-many through reviews):** Faker-generated reviewers each review several imported airports.
- Original source IDs are used only to find related rows while seeding; Rails creates new primary and foreign keys.

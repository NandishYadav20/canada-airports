source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.0"

# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 1.4"

# Use the Puma web server
gem "puma", ">= 5.0"

# CSV parsing (no longer a default gem in Ruby 3.4+)
gem "csv"

# Pagination (feature 3.5)
gem "kaminari"

# Fake data generation (data source for reviewers and reviews)
gem "faker"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end

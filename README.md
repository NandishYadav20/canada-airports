# Canada Airports – Rails Intro Project

A Ruby on Rails app to browse, search and map Canadian airports, the airlines flying between them, and traveller reviews.

## Setup

```bash
bundle install
rails db:migrate
rails db:seed
rails server
```

Open http://localhost:3000

## Features (for marking)

| # | Feature | Where |
|---|---------|-------|
| 1.1 | Describe Datasets | `docs/datasets.md`, About page |
| 1.2 | Database ERD | `docs/erd.png`, About page |
| 1.3 | 4+ AR Models | Province, Airport, Airline, Route, Reviewer, Review (`app/models`) |
| 1.4 | At least one association | Province `has_many :airports` / Airport `belongs_to :province` |
| 1.5 | Two or more many-to-many associations | Airline ↔ Airport through `routes`; Reviewer ↔ Airport through `reviews` |
| 1.6 | Validations | 2+ validations in every model |
| 1.7 | 3+ Data Sources | regions.csv, airports.csv, airlines.dat, routes.dat, Faker (`db/seeds.rb`) – 1,200+ rows |
| 2.1 | About Page | `/about` |
| 2.2 | Menu | Navbar on every page (`app/views/layouts/application.html.erb`) |
| 3.1 | Collection Navigation | `/provinces`, `/airports`, `/airlines`, `/reviewers` |
| 3.2 | Member Pages | Show page for every model with all attributes |
| 3.3 | Multi-model Data on Member Pages | Airport page shows province, airlines, routes and reviews |
| 3.4 | Hierarchical Collection Navigation | Province ⇄ Airport, Airline ⇄ Airport, Reviewer ⇄ Airport show pages link back and forth |
| 3.5 | Pagination | Kaminari on Airports, Airlines, Airline routes, Reviewers |
| 3.6 | Mapping | Leaflet + OpenStreetMap map on each Airport page and each Province page (GPS from airports.csv) |
| 4.1 | Simple Search | Airport text search (name, city, code) on Home and Airports pages |
| 4.2 | Hierarchical Search | Province/territory dropdown in the search form |
| 5.1 | Valid HTML | All pages validate as HTML5 |
| 5.2 | ERB Conditional | e.g. `if @airports.empty?` in `airports/index`, `if @reviews.any?` in `airports/show` |
| 5.3 | Bootstrap Grid | Bootstrap 5 grid (`row` / `col-*`) used in the layout and views |
| 6.1 | Git and GitHub | Git repository, pushed to GitHub |
| 6.2 | 20 Git Commits | See `git log` |

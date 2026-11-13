class AirportsController < ApplicationController
  def index
    @provinces = Province.order(:name)
    @airports = Airport.includes(:province).order(:name)

    if params[:q].present?
      term = "%#{Airport.sanitize_sql_like(params[:q].strip)}%"
      @airports = @airports.where(
        "airports.name LIKE :term OR airports.municipality LIKE :term OR airports.iata_code LIKE :term OR airports.ident LIKE :term",
        term: term
      )
    end

    @airports = @airports.where(province_id: params[:province_id]) if params[:province_id].present?
    @selected_province = @provinces.find { |p| p.id.to_s == params[:province_id].to_s }

    @airports = @airports.page(params[:page])
  end

  def show
    @airport = Airport.find(params[:id])
    @departing_routes = @airport.departing_routes
                                .includes(:airline, :destination_airport)
                                .joins(:destination_airport)
                                .order("airports.name")
    @reviews = @airport.reviews.includes(:reviewer).order(visited_on: :desc)
  end
end

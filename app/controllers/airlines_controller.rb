class AirlinesController < ApplicationController
  def index
    @airlines = Airline.left_joins(:routes)
                       .select("airlines.*, COUNT(routes.id) AS routes_count")
                       .group(:id)
                       .order(:name)
                       .page(params[:page])
  end

  def show
    @airline = Airline.find(params[:id])
    @airports = @airline.airports.includes(:province).order(:name)
    @routes = @airline.routes
                      .includes(:origin_airport, :destination_airport)
                      .joins(:origin_airport)
                      .order("airports.name")
                      .page(params[:page])
  end
end

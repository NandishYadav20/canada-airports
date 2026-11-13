class ProvincesController < ApplicationController
  def index
    @provinces = Province.left_joins(:airports)
                         .select("provinces.*, COUNT(airports.id) AS airports_count")
                         .group(:id)
                         .order(:name)
  end

  def show
    @province = Province.find(params[:id])
    @airports = @province.airports.order(:name)
  end
end

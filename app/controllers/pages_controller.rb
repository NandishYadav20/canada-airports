class PagesController < ApplicationController
  def home
    @provinces = Province.order(:name)
    @busiest_airports = Airport.left_joins(:departing_routes)
                               .group(:id)
                               .order(Arel.sql("COUNT(routes.id) DESC"))
                               .limit(5)
  end

  def about
  end
end

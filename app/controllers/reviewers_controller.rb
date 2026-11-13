class ReviewersController < ApplicationController
  def index
    @reviewers = Reviewer.left_joins(:reviews)
                         .select("reviewers.*, COUNT(reviews.id) AS reviews_count")
                         .group(:id)
                         .order(:name)
                         .page(params[:page])
  end

  def show
    @reviewer = Reviewer.find(params[:id])
    @reviews = @reviewer.reviews.includes(airport: :province).order(visited_on: :desc)
  end
end

module PlaceHelper
  def add_review
    @place.reviews.build(params[:review])
  end
end

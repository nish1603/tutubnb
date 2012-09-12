module PlaceHelper
  def add_review()
    @place.reviews.create(params[:review])
  end

  def average_ratings()
  	(Review.group(:place_id).having("place_id = #{@place.id}").average(:ratings)[@place.id]).to_i
  end
end

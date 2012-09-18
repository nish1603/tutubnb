module PlaceHelper
  def add_review()
  	@review = Review.new(params[:review])
    @place.reviews << @review if(@review.valid?)
    @review = Review.new if(@review.valid?)
  end

  def average_ratings()
  	(Review.group(:place_id).having("place_id = #{@place.id}").average(:ratings)[@place.id]).to_i
  end
end

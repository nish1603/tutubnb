class ReviewController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:place])
    respond_to do |format|
      @review.save
      format.html { render action: "new" }
    end
  end

  def show
  end
end

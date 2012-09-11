class ReviewController < ApplicationController
  def new
  	@review = Review.new
  end

  def create
  	@review = Review.new(params[:place])
  	respond_to do |format|
        format.html { render action: "new" }
      end
    end 
  end

  def edit
  end

  def show
  end

  def destroy
  end
end

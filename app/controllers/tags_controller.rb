class TagsController < ApplicationController
  skip_before_filter :authorize

  def index
  	params = request.parameters
  	@tags = Tag.tags_starting_with(params[:tag])
    
    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end
end
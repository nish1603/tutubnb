class TagController < ApplicationController
  skip_before_filter :authorize

  def index
  	params = request.parameters
  	@tags = []
  	@tags = Tag.find(:all,:conditions => ['tag LIKE ?', "#{params[:tag]}%"],  :limit => 10, :order => 'tag') if(params[:tag])
    @tags = @tags.map(&:tag)
    
    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end
end
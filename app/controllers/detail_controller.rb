class DetailController < ApplicationController
  def new
  	@detail = Detail.new
  end

  def create
  	@detail = Detail.new(params[:detail])
    @detail.place_id = session[:place_id]

    respond_to do |format|
      if @detail.save
        format.html { redirect_to price_new_path }
      end
    end 
  end

  def edit
  end

  def show
  end
end

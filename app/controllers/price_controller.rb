class PriceController < ApplicationController
  def new
  	@price = Price.new
  end

  def create
  	@price = Price.new(params[:price])
    @price.place_id = session[:price_id]
    session[:place_id] = nil

  	respond_to do |format|
      if @price.save
        format.html { redirect_to display_show_path }
      end
    end 
  end

  def edit
  end

  def show
  end
end

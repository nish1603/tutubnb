class PriceController < ApplicationController

  skip_before_filter :authorize, only: :show

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
    @price = Price.find(params[:id])
    validating_owner @price.place.user_id, price_path(params[:id])
  end

  def update
    @price = Price.find(params[:id])

    update_attributes @price, :price
  end

  def show
    @price = Price.find(params[:id])
  end
end

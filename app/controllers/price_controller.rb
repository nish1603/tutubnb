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

    respond_to do |format|
      if session[:user_id] != @price.place.user_id
        format.html { redirect_to display_show_path }
      else
        format.html 
      end
    end
  end

  def update
    @price = Price.find(params[:id])

    respond_to do |format|
      if@price.update_attributes(params[:price])
        format.html { redirect_to @price }
      end
    end
  end

  def show
  end
end

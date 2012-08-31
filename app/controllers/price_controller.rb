class PriceController < ApplicationController
  def new
  	@price = Price.new

    respond_to do |format|
      if !session[:user_id].nil?
        format.html 
      else
        format.html { redirect_to profile_login_path }
      end
    end
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

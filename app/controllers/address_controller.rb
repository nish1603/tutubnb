class AddressController < ApplicationController

  skip_before_filter :authorize, only: :show

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])
    @address.place_id = session[:place_id]

    respond_to do |format|
      if @address.save
        format.html { redirect_to new_price_path }
      end
    end 
  end

  def edit
    @address = Address.find(params[:id])
    
    if !@address.nil?
      validating_owner @address.place.user_id, address_path(params[:id])
    end
  end

  def update
    @address = Address.find(params[:id])
    update_attributes @address, :address
  end

  def show
    @address = Address.find(params[:id])
  end

  def destroy
  end
end
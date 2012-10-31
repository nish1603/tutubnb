class DetailsController < ApplicationController

  skip_before_filter :authorize, only: :show

  def new
  	@detail = Detail.new
  end

  def create
  	@detail = Detail.new(params[:detail])
    @detail.place_id = session[:place_id]

    respond_to do |format|
      if @detail.save
        format.html { redirect_to new_address_path }
      end
    end 
  end

  def edit
    @detail = Detail.find(params[:id])
    
    if !@detail.nil?
      validating_owner @detail.place.user_id, detail_path(params[:id])
    end
  end

  def update
    @detail = Detail.find(params[:id])
    update_attributes @detail, :detail
  end

  def show
    @detail = Detail.find(params[:id])
  end

  def destroy
  end
end

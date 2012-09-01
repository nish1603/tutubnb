class DetailController < ApplicationController

  skip_before_filter :authorize, only: :show

  def new
  	@detail = Detail.new
  end

  def create
  	@detail = Detail.new(params[:detail])
    @detail.place_id = session[:place_id]

    respond_to do |format|
      if @detail.save
        format.html { redirect_to new_price_path }
      end
    end 
  end

  def edit
    @detail = Detail.find(params[:id])
    validate_owner @detail.place.user_id, show_detail_path

    respond_to do |format|
      format.html 
    end
  end

  def update
    @detail = Detail.find(params[:id])

    update_attributes @detail, :detail
  end

  def show
    @detail = Detail.find(params[:id])
  end
end

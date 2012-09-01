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
        format.html { redirect_to price_new_path }
      end
    end 
  end

  def edit
    @detail = Detail.find(params[:id])

    respond_to do |format|
      if session[:user_id] != @price.place.user_id
        format.html { redirect_to display_show_path }
      else
        format.html 
      end
    end
  end

  def update
    @detaail = Detail.find(params[:id])

    respond_to do |format|
      if@detail.update_attributes(params[:price])
        format.html { redirect_to @detail }
      end
    end
  end

  def show
  end
end

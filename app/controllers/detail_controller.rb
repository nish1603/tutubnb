class DetailController < ApplicationController
  def new
  	@detail = Detail.new

    respond_to do |format|
      if !session[:user_id].nil?
        format.html 
      else
        format.html { redirect_to profile_login_path }
      end
    end
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

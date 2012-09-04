class DealController < ApplicationController
  def new
  	@deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
    #@deal.cancel = false
    @deal.user_id = session[:user_id]
    @deal.place_id = session[:place_id]
    session[:place_id] = nil


    respond_to do |format|
      if @deal.save
        format.html { redirect_to deal_path(@deal.id) }
      end
    end
  end

  def reply
    @deal = Deal.find(params[:id])

    if(params[:perform] == :accept)
      res = true
    else
      res = false
    end
    
    @deal.accept = res
    @deal.request = false

    respond_to do |format|
      if @deal.save
        format.html { redirect_to user_requests_path(session[:user_id]), notice: "Deal has been #{params[:perform]}ed."  }
      end
    end
  end

  def cancel
    @deal = Deal.find(param[:id])
    @deal.accept = nil
    @deal.cancel = true
  end

  def show
  end
end

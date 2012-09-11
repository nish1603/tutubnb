class DealController < ApplicationController
  def new
  	@deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
    @deal.cancel = false
    @deal.place_id = params[:place_id]
    @deal.user_id = session[:user_id]

    @deal.price = DealHelper.calculate_price(@deal, @deal.place)

    respond_to do |format|
      if(params[:commit] == "Book Place" and @deal.save)
        format.html { redirect_to place_path(@deal.place.id) }
      else
        format.html { render "new" }
      end
    end
  end

  def reply
    @deal = Deal.find(params[:id])

    if(params[:perform] == :accept)
      res = true
      @deal.user.wallet -= @deal.price 
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

  
end
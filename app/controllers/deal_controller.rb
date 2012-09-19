class DealController < ApplicationController
  def new
  	@deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
    @deal.place_id = params[:place_id]
    @deal.user_id = session[:user_id]

    event_validate, key, msg = DealHelper.check_deal(@deal, @deal.place)

    @deal.price, @division = DealHelper.calculate_price(@deal, @deal.place) if event_validate == true

    respond_to do |format|
      if(params[:commit]  == "Book Place" and event_validate == true and @deal.save)
        flash[:notice] = "You have successfully booked the place."
        format.html { redirect_to place_path(@deal.place.id) }
      else
        flash[:error] = @deal.errors.full_messages.first if(@deal.errors.any?)
        flash[key] = msg
        format.html { render "new" }
      end
    end
  end

  def reply
    @deal = Deal.find(params[:id])
    @deal.request = false

    if(params[:perform] == "accept")
      res = true
      @admin, @requestor = DealHelper.transfer_to_admin(@deal)
      DealHelper.reject_deals(@deal, @deal.place)
    else
      res = false
    end
    
    @deal.accept = res

    respond_to do |format|
      if(@deal.save and (res == false or (@requestor.save and @admin.save)))
        flash[:notice] = "Deal has been #{params[:perform]}ed."
        format.html { redirect_to user_requests_path(session[:user_id])}
      end
    end
  end

  def cancel
    @deal = Deal.find(params[:id])
    @deal.accept = nil
    @deal.cancel = true
  end

  def complete
    @deal = Deal.find(params[:id])
    @deal.complete = true

    @admin, @owner = DealHelper.transfer_from_admin(@deal)

    respond_to do |format|
      if(@deal.save and @admin.save and @owner.save)
        format.html { redirect_to admin_deals_path }
        flash[:notice] = "#{@deal.price * 0.9} has been added to #{@owner.first_name} to your wallet."
      end
    end
  end
end
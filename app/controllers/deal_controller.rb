class DealController < ApplicationController
  def new
  	@deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
    @deal.cancel = false
    @deal.place_id = params[:place_id]
    @deal.user_id = session[:user_id]

    event_validate, key, msg = DealHelper.check_deal(@deal, @deal.place)

    @deal.price = DealHelper.calculate_price(@deal, @deal.place) if event_validate == true

    respond_to do |format|
      if(params[:commit]  == "Book Place" and event_validate == true and @deal.save)
        owner = User.find(@deal.place.user_id)
        text = "A User requested your place."
        link = user_requests_url(owner.id)
        flash[:notice] = "You have successfully booked the place."

        Notifier.notification(text, link, owner.email, owner.first_name, 'New Request').deliver
        format.html { redirect_to place_path(@deal.place.id) }
      else
        flash[key] = msg
        format.html { render "new" }
      end
    end
  end

  def reply
    @deal = Deal.find(params[:id])
    @requestor = @deal.user
    @admin = User.admin.first

    if(params[:perform] == :accept)
      res = true
      @requestor.wallet -= (@deal.price * 1.1) 
      @admin.wallet += (@deal.price * 1.1)
    else
      res = false
    end
    
    @deal.accept = res
    @deal.request = false

    respond_to do |format|
      if @deal.save and @requestor.save and @admin.save
        flash[:notice] = "Deal has been accepted."
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
     
    User.admin.wallet -= (@deal.price * 0.9)
    @deal.place.user.wallet += (@deal.price * 0.9)

    respond_to do |format|
      if(@deal.save and User.admin.save and @deal.place.user.save)
        owner = user.find(@deal.place.user_id)
        text = "#{@deal.price * 0.9} has been added to your wallet."
        link = ""
        Notifier.notification(text, link, owner.email, owner.first_name, 'Deal Complete').deliver
        format.html { redirect_to admin_deals_path }
      end
    end
  end
end
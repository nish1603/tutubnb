class DealController < ApplicationController
  def new
  	@deal = Deal.new
    @deal.place_id = params[:place_id]
    @deal.user_id = session[:user_id]
    @no_guests = (1..@deal.place.detail.accomodation).to_a
  end

  def create
    @deal = Deal.new(params[:deal])
    @deal.place_id = params[:place_id]
    @deal.user_id = session[:user_id]
    @no_guests = (1..@deal.place.detail.accomodation).to_a
    @deal.price = 0.0

    @deal.price, @division = DealHelper.calculate_price(@deal, @deal.place) if @deal.valid?

    respond_to do |format|
      if(params[:commit]  == "Book Place" and @deal.save)
        flash[:notice] = "You have successfully booked the place."
        format.html { redirect_to place_path(@deal.place.id) }
      else
        flash[:error] = @deal.errors.full_messages.first if(@deal.errors.any?)
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
      notify_visitor = "Your request for {@deal.place.title} has been accepted."
      link_visitor = user_visits_path(@requestor.id)
      DealHelper.reject_deals(@deal, @deal.place)
    else
      res = false
      notify_visitor = "Your request for {@deal.place.title} has been rejected by the owner."
      link_visitor = user_visits_url(@deal.user.id)
    end
    
    @deal.accept = res

    respond_to do |format|
      if(@deal.save and (res == false or (@requestor.save and @admin.save)))
        Notifier.notification(notify_visitor, link_visitor, @deal.user.email, @deal.user.first_name, 'Deal #{params[:perform].capitalize}ed.').deliver
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

    notify_visitor = "#{(@deal.price*0.9).round(2)} has been added to your wallet for the deal at #{@deal.place.title} from #{@deal.start_date} to #{@deal.end_date}."
    link_visitor = ''

    @admin = User.admin.first  
    @owner = @deal.place.user

    @admin.wallet -= (@deal.price * 0.9)
    @owner.wallet += (@deal.price * 0.9)

    respond_to do |format|
      if(@deal.save and @admin.save and @owner.save)
        Notifier.notification(notify_visitor, link_visitor, @deal.place.user.email, @deal.place.user.first_name, "Deal #{params[:perform].capitalize}ed.").deliver
        format.html { redirect_to admin_deals_path }
        flash[:notice] = "#{@deal.price * 0.9} has been added to #{@owner.first_name} to your wallet."
      end
    end
  end
end
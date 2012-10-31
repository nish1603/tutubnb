class DealsController < ApplicationController

  def index
    @deals = Deal.all

    respond_to do |format|
      format.html
      format.js
    end
  end

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

    @deal.calculate_price() if @deal.valid?
    
    respond_to do |format|
      if(params[:commit]  == "Book Place" && @deal.save)
        flash[:notice] = "You have successfully booked the place."
        format.html { redirect_to place_path(@deal.place.id) }
      else
        flash[:error] = @deal.errors.full_messages.first if(@deal.errors.any?)
        format.html { render "new" }
      end
    end
  end

  def reply
    @deal = Deal.find_by_id(params[:id])
    @deal.reply_to_deal(params[:perform])
    
    notify_visitor = "Your request for {@deal.place.title} has been #{params[:perform]}ed."
    link_visitor = visits_user_path(@deal.user_id)

    respond_to do |format|
      if(@deal.save)
        Notifier.notification(notify_visitor, link_visitor, @deal.user.email, @deal.user.first_name, 'Deal #{params[:perform].capitalize}ed.').deliver
        flash[:notice] = "Deal has been #{params[:perform]}ed."
        format.html { redirect_to requests_user_path(session[:user_id])}
      end
    end
  end

  def complete
    @deal = Deal.find(params[:id])

    notify_visitor = "#{(@deal.price*0.9).round(2)} has been added to your wallet for the deal at #{@deal.place.title} from #{@deal.start_date} to #{@deal.end_date}."
    link_visitor = ''

    respond_to do |format|
      if(@deal.mark_completed!)
        Notifier.notification(notify_visitor, link_visitor, @deal.owner.email, @deal.owner.first_name, "Deal #{params[:perform].capitalize}ed.").deliver
        format.html { redirect_to admin_deals_path }
        flash[:notice] = "#{@deal.price * 0.9} has been added to #{@owner.first_name} to your wallet."
      end
    end
  end
end
class DealsController < ApplicationController

  after_filter :send_mail_after_reply, :only => :reply
  before_filter :check_access, :only => :reply

  def new
  	@deal = current_user.deals.build
    @deal.place_id = params[:place_id]
    @no_guests = (1..@deal.place.detail.accomodation).to_a
    @deal.price = 0.0
  end

  def create
    @deal = current_user.trips.build(params[:deal])
    @deal.place_id = params[:place_id]
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
    
    respond_to do |format|
      if(params[:perform] == "accept" && @deal.accept!)
        flash[:notice] = "Deal has been accepted."
        format.html { redirect_to requests_user_path(session[:user_id])}
      elsif(params[:perform] == "reject" && @deal.reject!)
        flash[:notice] = "Deal has been rejected."
        format.html { redirect_to requests_user_path(session[:user_id])}
      else
        flash[:alert] = @deal.errors.full_messages.first
        format.html { redirect_to root_url }
      end
    end
  end

  def send_mail_after_reply
    @deal = Deal.find_by_id(params[:id])

    notify_visitor = "Your request for {@deal.place.title} has been #{params[:perform]}ed."
    link_visitor = visits_user_path(@deal.user_id)

    Notifier.delay(:queue => 'verification').notification(notify_visitor, link_visitor, @deal.user.email, @deal.user.first_name, "Deal #{params[:perform].capitalize}ed.")
  end

  protected
    def check_access
      @deal = Deal.find_by_id(params[:id])
      if((@deal.owner != current_user) && (@deal.user == current_user && params[:perform] != "reject"))
        redirect_to root_url
        flash[:alert] = "You are not authorized to do this action."
      end
    end
end
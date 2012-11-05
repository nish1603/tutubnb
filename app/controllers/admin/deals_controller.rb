class Admin::DealsController < ApplicationController  

  before_filter :confirm_admin, :only => [:complete]
  after_filter :send_mail_after_completion, :only => :complete

  def complete
    @deal = Deal.find_by_id(params[:id])

    respond_to do |format|
      if(@deal.mark_completed!)
        format.html { redirect_to admin_deals_path }
        flash[:notice] = "#{@deal.price * 0.9} has been added to #{@owner.first_name} to your wallet."
      end
    end

  def send_mail_after_completion
    @deal = Deal.find_by_id(params[:id])

    notify_visitor = "#{(@deal.price*0.9).round(2)} has been added to your wallet for the deal at #{@deal.place.title} from #{@deal.start_date} to #{@deal.end_date}."
    link_visitor = edit_user_path(@deal.user_id)

    Notifier.delay(:queue => 'notification').notification(notify_visitor, link_visitor, @deal.owner.email, @deal.owner.first_name, "Deal #{params[:perform].capitalize}ed.")
  end
end
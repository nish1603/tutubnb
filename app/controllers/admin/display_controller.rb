class Admin::DisplayController < ApplicationController
  
  before_filter :confirm_admin, :only => [:user, :deals]
  
  def user
    @users = User.all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def deals
    @deals = Deal.all

    respond_to do |format|
      format.html
      format.js
    end
  end
end

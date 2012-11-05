
class Admin::UsersController < ApplicationController
  
  before_filter :confirm_admin, :only => [:wallet, :activate]

  def wallet
    @user = User.find(params[:id])

    @user.update_wallet(params[:commit], params[:amount].to_f)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path }
      end
    end
  end

  def activate
    @user = User.find(params[:id])

    respond_to do |format|
      if(perform_activate(@user))
        flash[:notice] = "Account #{@user.first_name} is now #{params[:flag]}"
      else
        flash[:error] = "Acoount #{@user.first_name} has not been activated"
      end
      format.html { redirect_to admin_users_path }
    end
  end

  def perform_activate(user)
    if(params[:flag] == "active")
      return user.activate!
    elsif(params[:flag] == "deactive")
      return user.deactivate!
    end
    return false
  end
end
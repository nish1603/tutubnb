class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to profile_login_path, notice: "Please log in"
    end
  end

  def validating_owner(owner_id, show_path)
  	respond_to do |format|
      if session[:user_id] != owner_id
  		  format.html { redirect_to show_path }
      else
        format.html
      end
    end
  end

  def update_attributes(to_update, photos, type_to_update)
    respond_to do |format|
      if(photos >= 2 and to_update.update_attributes(params[type_to_update]))
        @place.hidden = false
        @place.save
        format.html { redirect_to to_update }
      elsif photos < 2
        to_update.valid?
        to_update.errors.add(:base, "Photos should be at least 2")
        format.html { render action: "new" }
      else
        format.html { render action: "edit"}
      end
    end
  end

  def validate_account
    if(session[:user_id] != params[:id].to_i)
      redirect_to display_show_path
    end
  end

  def user_activated
    if(self.user.activated == false)
      flash[:alert] = "Owner of this place is deactivated. Please activate him first."
      redirect_to admin_user_path
    end
  end 
end

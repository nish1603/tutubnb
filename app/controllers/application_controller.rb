class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize
  before_filter :set_i18n_locale_from_session


  def set_i18n_locale_from_session
    
    if session[:locale]
      if I18n.available_locales.include?(session[:locale].to_sym)
        I18n.locale = session[:locale]
      else
        flash.now[:notice] = "#{session[:locale]} translation not available"
      end
    end
  end


  def current_user
    if(session[:user_id].present?)
      @current_user ||= User.find_by_id(session[:user_id])
    else
      nil
    end
  end

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_sessions_path
      flash[:alert] = "Please log in"
    end
  end

  def validating_owner
    place = Place.find_by_id(params[:id])
    if(place.user_id != session[:user_id])
      redirect_to root_url
    end
  end

  def update_attributes(to_update, photos, type_to_update)
    # respond_to do |format|
    #   if(photos >= 2 and to_update.update_attributes(params[type_to_update]))
    #     @place.hidden = false
    #     @place.save
    #     format.html { redirect_to to_update }
    #   elsif photos < 2
    #     to_update.valid?
    #     to_update.errors.add(:base, "Photos should be at least 2")
    #     format.html { render action: "new" }
    #   else
    #     format.html { render action: "edit"}
    #   end
    # end
  end

  def validate_account
    if(session[:user_id].to_i != params[:id].to_i)
      redirect_to root_url
    end
  end

  def owner_activated
    place = Place.find_by_id(params[:id])
    if(place.user.activated == false)
      flash[:alert] = "Owner of this place is deactivated. Please activate him first."
      redirect_to admin_users_path
    end
  end

  def user_exist_by_email
    user = User.find_by_email(params[:email])
    if(user.nil?)
      redirect_to login_profile_index_path
      flash[:error] = 'Invalid E-mail Address.'
    end
  end

  def user_verified
    user = User.find_by_email(params[:email])
    if(user.verified == false)
      redirect_to login_sessions_path
      flash[:alert] = 'You have not verified your user account.'
    end
  end

  def user_activated
    user = User.find_by_email(params[:email])
    if(user.activated == false)
      redirect_to profile_login_path
      flash[:alert] = 'You are deactivated by the admin of this site.'
    end
  end

  def user_logged_in
    if(session[:user_id])
      redirect_to root_url
      flash[:alert] = "Sorry, you are already logged in."
    end
  end

  def confirm_admin
    if(session[:admin] == false)
      redirect_to root_url
    end
  end
 
  def place_exists
    place = Place.find_by_id(params[:id])
    if(place.nil?)
      redirect_to root_url
    end
  end

  def set_session(user_id)
    session[:user_id] = user_id
    session[:user_name] = current_user.first_name
    session[:admin] = current_user.admin
  end

  def clear_session
    session[:user_id] = nil
    session[:user_name] = nil
    session[:admin] = nil
    @current_user = nil
  end
end
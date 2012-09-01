class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to profile_login_path, notice: "Please log in"
    end
  end

  def validate_owner owner_id, show_path
  	if session[:user_id] != owner_id
  		redirect_to show_path, notice: "Please log in"
  	end
  end

  def update_attributes to_update, type_to_update
    if to_update.update_attributes(params[type_to_update])
      format.html { redirect_to to_update }
    end
  end
end

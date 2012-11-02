class SessionsController < ApplicationController

  skip_before_filter :authorize
  before_filter :user_exist_by_email, :user_verified, :user_activated, :only => [:validate_user]
  before_filter :user_logged_in, :only => [:login, :signup, :authenticate, :forget_password, :change_password]

#FIXME_AB: should be done in sessions controller
  def locale
    session[:locale] = params[:locale]

    respond_to do |format|
      format.html { redirect_to request.referrer }
    end
  end

  def login
  end

  def validate_user
    user = User.find_by_email(params[:email])

    respond_to do |format|
      if(user.authenticate(params[:password]))
        set_session(user.id)
        format.html { redirect_to root_url }
      else
        format.html { redirect_to login_profile_index_path }
        flash[:error] = 'E-mail Address/Password doesn\'t match.'
      end
    end
  end

#FIXME_AB: should be done in sessions controller
  def logout
    clear_session()

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
end

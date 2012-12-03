class AuthenticateController < ApplicationController
  skip_before_filter :authorize

  def index
    user = User.find_by_id(session[:user_id])
    @authentications = user.authentications
  end

  def create
    
    auth = request.env["omniauth.auth"]

    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
 
    if(authentication)
      if(current_user.nil?)
        flash[:notice] = "Signed in successfully."
        check_sign_in_and_redirect(authentication.user)
      elsif(session[:user_id] != authentication.user_id)
        flash[:error] = "The #{authentication.provider} account has already been added by some other user."
        redirect_to root_url
      else
        flash[:alert] = "You have already linked this account"
        redirect_to root_url
      end
    else      
      user = User.create_with_authentication(auth, current_user)
      if user
        check_sign_in_and_redirect(user)
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      end
    end
  end

  def check_sign_in_and_redirect(user)
    respond_to do |format|
      set_session(user.id) if(current_user.blank?)
      flash[:notice] = "Account has been linked"
      format.html { redirect_to root_url } 
    end
  end

  def destroy
    user = User.find(session[:user_id])
    @authentication = user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
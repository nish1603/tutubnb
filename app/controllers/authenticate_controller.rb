class AuthenticateController < ApplicationController
  skip_before_filter :authorize

  def index
    user = User.find(session[:user_id])
    @authentications = user.authentications
  end

  def create
    auth = request.env["omniauth.auth"]
 
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
 
    if(authentication)
      if(session[:user_id].nil?)
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(authentication.user)
      elsif(session[:user_id] != authentication.user_id)
        flash[:error] = "The #{authentication.provider} account has already been added by some other user."
      else
        flash[:alert] = "You have already linked this account"
      end
    else
      #user = authentication.find_or_initialize_user_by_email(auth['info']['email'])

      if(session[:user_id].nil?)
        user = User.new
        flash[:notice] = "Account created and signed in successfully."
      else
        user = User.find_by_id(session[:user_id])
        flash[:notice] = "Acccount has been linked."
      end
      user.apply_omniauth(auth)
      if user.save(:validate => false)
        sign_in_and_redirect(user)
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      end
    end
  end

  def sign_in_and_redirect(user)
    respond_to do |format|
      set_session(user.id)
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
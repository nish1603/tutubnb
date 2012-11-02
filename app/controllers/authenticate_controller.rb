class AuthenticateController < ApplicationController
  skip_before_filter :authorize

  def index
    user = User.find_by_id(session[:user_id])
    @authentications = user.authentications
  end

  def create
    
    auth = request.env["omniauth.auth"]
    @auth = auth.clone
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
 
    if(authentication)
      if(session[:user_id].nil?)
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(authentication.user)
      elsif(session[:user_id] != authentication.user_id)
        flash[:error] = "The #{authentication.provider} account has already been added by some other user."
        redirect_to root_url
      else
        flash[:alert] = "You have already linked this account"
        redirect_to root_url
      end
    else
      if(session[:user_id].nil?)
        user = User.find_by_email(auth['info']['email']) || User.new
        flash[:notice] = "Account created and signed in successfully."
      else
        user = User.find_by_id(session[:user_id])
        flash[:notice] = "Acccount has been linked."
      end
      user.create_user_with_omniauth(auth)
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

  def tweet

    Twitter.configure do |config|
      config.consumer_key       = "hy8b0hn6OMJhyw1qaoUuvQ"
      config.consumer_secret    = "w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w"
      config.oauth_token        = current_user.authentications.first.token
      config.oauth_token_secret = current_user.authentications.first.secret
    end
    Twitter.update 'Yo buudy'
  end
end
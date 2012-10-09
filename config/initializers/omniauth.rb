OmniAuth.config.logger = Rails.logger


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "438392172863385", "831b45fc6101aa0cca6d5e4f2548bb34", :scope => 'email,user_birthday,read_stream', :display => 'popup'
  provider :twitter, "hy8b0hn6OMJhyw1qaoUuvQ", "w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w", :display => 'popup'
  provider :linkedin, "viac2geyrs0w", "Ie8aePTPZZtT2pUx", :display => 'popup'
end

# ctoken = "hy8b0hn6OMJhyw1qaoUuvQ"
# csecret = "w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w"

# oa = OAuth::Consumer.new(ctoken, csecret, :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
# rt = oa.get_request_token
# rsecret = rt.secret
# rtoken = rt.token

# at = rt.get_access_token
# asecret = at.secret
# atoken = at.token


# Twitter.configure do |config|
# 	  config.consumer_key       = ctoken
# 	  config.consumer_secret    = csecret
# 	  config.oauth_token        = atoken
# 	  config.oauth_token_secret = asecret
# end
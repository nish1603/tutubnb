OmniAuth.config.logger = Rails.logger


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "438392172863385", "831b45fc6101aa0cca6d5e4f2548bb34", :scope => 'email,user_birthday,read_stream', :display => 'popup'
  provider :twitter, "hy8b0hn6OMJhyw1qaoUuvQ", "w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w", :display => 'popup'
  provider :linkedin, "viac2geyrs0w", "Ie8aePTPZZtT2pUx", :display => 'popup'
end


Twitter.configure do |config|
  config.consumer_key       = 'hy8b0hn6OMJhyw1qaoUuvQ'
  config.consumer_secret    = 'w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w'
  config.oauth_token        = '114426644-yKUs3bi8c3LwZLDziI9uYqEeBYWo1fyO4ndTDsZ4'
  config.oauth_token_secret = '0Kw7nHS3FO5FqYImjTkjUZLpdRL2hwO6NxqeDOLafw'
end

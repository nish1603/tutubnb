OmniAuth.config.logger = Rails.logger

#Rails.application.config.middleware.use OmniAuth::Builder do provider :facebook, 'my App ID:', 'my app Secret' end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email,user_birthday,read_stream', :display => 'popup'
  provider :twitter, "hy8b0hn6OMJhyw1qaoUuvQ", "w7WImhhWiQWo2l1XlW1EKr8yT9SavoxGRJvq8FAT0w", :display => 'popup'
  provider :linkedin, "viac2geyrs0w", "Ie8aePTPZZtT2pUx", :display => 'popup'
end
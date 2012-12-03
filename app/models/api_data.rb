class ApiData < ActiveRecord::Base
  attr_accessible :url
  self.table_name = :api_datas

  belongs_to :user

  def generate_token_and_secret()
  	self.token = SecureRandom.urlsafe_base64(n = 32)
  end

  def authenticate(email, password)
    if(user.email == email)
      generate_token_and_secret()
    	return user.authenticate(password)
    else 
    	return false
    end
  end

  def authenticate_token(input_token)
    return self.token == input_token
  end
end
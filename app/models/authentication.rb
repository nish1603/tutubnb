class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :secret

  belongs_to :user
end

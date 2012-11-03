class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :secret

  validates :provider, :uniqueness => { :scope => :uid, :message => 'has already been linked.' }

  belongs_to :user
end

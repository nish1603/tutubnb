
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password

  validates :first_name, :last_name, :email, :email, presence: true
  validates :email, uniqueness: true 
  has_secure_password

  has_many :places

  Gender = ['Male', 'Female']
end

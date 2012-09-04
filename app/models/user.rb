
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :describe, :work, :live, :birth_date, :school

  validates :first_name, :last_name, :email, :gender, :password, presence: true
  validates :email, uniqueness: true 
  has_secure_password

  has_many :places
  has_many :deals

  GENDER = ['Male', 'Female', 'Other']
end

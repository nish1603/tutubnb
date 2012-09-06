
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :describe, :work, :live, :birth_date, :school, :avatar

  validates :first_name, :last_name, :email, :gender, presence: true
  validates :password, presence: true, :on => :create
  validates :birth_date, presence: true, :on => :update
  validates :email, uniqueness: true 
  has_secure_password
  has_attached_file :avatar

  has_many :places, :dependent => :delete_all
  has_many :trips, :class_name => 'Deal'
  has_many :deals, :through => :places

  GENDER = ['Male', 'Female', 'Other']
end

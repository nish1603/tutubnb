
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :describe, :work, :live, :birth_date, :school, :avatar

  validates :first_name, :last_name, :email, :gender, presence: true, :on => :create
  validates :password, presence: true, :on => :create
  validates :avatar, presence: true, :on => :update_dp
  validates :email, uniqueness: true 
  has_secure_password
  has_attached_file :avatar
  validates_format_of :avatar, :with => %r{\.(jpg|png|gif|jpeg)}i, :message => "Image only of .jpg, .jpeg, .gif and .png format is allowed."

  has_many :places, :dependent => :delete_all
  has_many :trips, :class_name => 'Deal', :dependent => :nullify
  has_many :deals, :through => :places
  has_many :reviews

  GENDER = ['Male', 'Female', 'Other']
end

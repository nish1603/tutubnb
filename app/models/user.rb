
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :password_confirmation, :describe, :work, :live, :birth_date, :school, :avatar, :admin, :wallet, :activate

  validates :first_name, :last_name, :gender, :presence => true
  validates :password, :presence => true, :length => { :minimum => 6 }, :confirmation => true, :if => :password
  validates :email, :presence => true, :uniqueness => true, format: { :with => /^([a-zA-Z]([a-zA-Z0-9+.\-][.]?)*@[a-zA-Z0-9]+.[a-zA-Z]{2,4}.[a-zA-Z]{0,3})$/, :message => "Invalid Email Address" }

  has_secure_password
  has_attached_file :avatar, :styles => { :thumb => "150x150>" }
  validates_format_of :avatar, :with => %r{\.(jpg|png|gif|jpeg)}i, :message => "Image only of .jpg, .jpeg, .gif and .png format is allowed."

  has_many :places, :dependent => :destroy
  has_many :trips, :class_name => 'Deal', :dependent => :nullify
  has_many :deals, :through => :places
  has_many :reviews, :dependent => :delete_all

  GENDER = ['Male', 'Female', 'Other']
  TYPE = ['Activated', 'Deactivated', 'Not_Verified', 'All']

  scope :admin, where(:admin => true)
  scope :by_email, lambda{ |user| where(:email => user.email)}
  scope :activated, where(:verified => true, :activated => true)
  scope :deactivated, where(:activated => false)
  scope :not_verified, where(:verified => false)
end
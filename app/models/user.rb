
class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :password_confirmation, :describe, :work, :live, :birth_date, :school, :avatar, :activate

  validates :first_name, :last_name, :gender, :email, :presence => true
  validates :email, format: { :with => /^([a-zA-Z]([a-zA-Z0-9+.\-][.]?)*@[a-zA-Z0-9]+.[a-zA-Z]{2,4}.[a-zA-Z]{0,3})$/, :message => "Invalid Email Address" }, :unless => proc { |user| user.email.blank? }
  validates :email, :uniqueness => true, :unless => proc { |user| user.errors[:email].any? }
  validates :password, :presence => true, :if => :password
  validates :password, :length => { :minimum => 6 }, :if => :password, :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :if => :password

  has_secure_password
  has_attached_file :avatar, :styles => { :thumb => "150x150>" }
  validates_format_of :avatar, :with => %r{\.(jpg|png|gif|jpeg)}i, :message => "Image only of .jpg, .jpeg, .gif and .png format is allowed."

  has_many :places, :dependent => :destroy
  has_many :trips, :class_name => 'Deal', :dependent => :nullify
  has_many :deals, :through => :places
  has_many :reviews, :dependent => :delete_all
  has_many :authentications, :dependent => :delete_all

  before_destroy :has_pending_deals?

  GENDER = {'Male' => 1, 'Female' => 2, 'Other' => 3}
  TYPE = ['Activated', 'Deactivated', 'Not_Verified', 'All']

  scope :admin, where(:admin => true)
  scope :by_email, lambda{ |user| where(:email => user.email)}
  scope :activated, where(:verified => true, :activated => true)
  scope :deactivated, where(:activated => false)
  scope :not_verified, where(:verified => false)

  def apply_omniauth(auth)
    self.email = auth['extra']['raw_info']['email']
    self.first_name = auth['extra']['raw_info']['screen_name']
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def update_wallet(commit_type, amount)
    if(commit_type == "Add")
      wallet = wallet + amount
    else
      wallet = wallet - amount
    end
  end

  def has_pending_deals?
    unless(deals.completed(false).requested(true).empty? && trips.completed(false).requested(true).empty?)
      return false
    end
  end

  def activate_or_deactivate_user(active_flag)
    if(active_flag == 'active')
      active = true
    else
      active = false
    end

    activated = active

    places.each do |place|
      place.verified = active
    end
  end

  def activate_or_deactivate_user
  end
end

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :password_confirmation, :describe, :work, :live, :birth_date, :school, :avatar, :activate

  validates :first_name, :presence => true
  validates :last_name, :presence => true, :if => :last_name
  validates :gender, :presence => true, :if => :gender
  validates :email, :presence => true, :if => :email
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

  def create_user_with_omniauth(auth)
    if(self.new_record?)
      self.email = auth['info']['email']
      self.first_name, self.last_name = auth['info']['name'].split(' ')
      self.last_name = auth['info']['last_name'] if(self.last_name.nil?)
    end
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def update_wallet(commit_type, amount)
    if(commit_type == "Add")
      self.wallet += amount
    else
      self.wallet -= amount
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

    self.activated = active

    places.each do |place|
      place.verified = active
      place.save
    end
  end

  def tarnsfer_from_admin(price)
    admin = User.admin.first

    self.wallet += (price * 0.9) 
    admin.wallet -= (price * 0.9)
    admin.save
  end

  def transfer_to_admin(price)
    admin = User.admin.first

    self.wallet -= (price * 1.1) 
    admin.wallet += (price * 1.1)
    admin.save
  end
end

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :gender, :last_name, :password, :password_confirmation, :describe, :work, :live, :birth_date, :school, :avatar, :activate


  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :gender, :presence => true
  validates :email, :presence => true#, :if => proc { |user| user.authentication_of_email == 'no' }
  validates :email, format: { :with => /^([a-zA-Z]([a-zA-Z0-9+.\-][.]?)*@[a-zA-Z0-9]+.[a-zA-Z]{2,4}.[a-zA-Z]{0,3})$/, :message => "Invalid Email Address" }, :unless => proc { |user| user.email.blank? }
  validates :email, :uniqueness => true, :unless => proc { |user| user.errors[:email].any? }
  validates :password, :presence => true, :if => proc { |user| user.nil? && user.authentication_of_password }
  validates :password, :length => { :minimum => 6 }, :if => :password, :unless => proc { |user| user.password.blank? }
  validates :password_confirmation, :presence => true, :if => :password

  has_secure_password
  
  has_attached_file :avatar, :styles => { :thumb => "150x150>" }
  validates_format_of :avatar, :with => %r{\.(jpg|png|gif|jpeg)}i, :message => "Image only of .jpg, .jpeg, .gif and .png format is allowed."

  has_many :places, :dependent => :destroy
  has_many :trips, :class_name => 'Deal', :dependent => :nullify
  has_many :deals, :through => :places
  has_many :reviews, :dependent => :destroy
  has_many :authentications, :dependent => :destroy
  has_many :api_datas, :dependent => :destroy

  before_destroy :has_pending_deals?

  TYPE = ['Activated', 'Deactivated', 'Not_Verified', 'All']
  ARTH_OPERATION = {"Add" => 1, "Subtract" => 0}

  scope :admin, where(:admin => true)
  scope :by_email, lambda{ |user| where(:email => user.email)}
  scope :activated, where(:verified => true, :activated => true)
  scope :deactivated, where(:activated => false)
  scope :not_verified, where(:verified => false)

  def self.gender()
    {I18n.t('male') => 1, I18n.t('female') => 2, I18n.t('other') => 3}
  end

  def self.create_with_authentication(auth, current_user)
    current_user = user_for_authentication(auth, current_user)
    current_user.create_with_authentication(auth)
    current_user
  end

  def self.user_for_authentication(auth, current_user)
    current_user = User.find_by_email(auth['info']['email']) || User.new if current_user.blank?
    current_user
  end

  def create_with_authentication(auth)
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64(n = 6)

    if(self.new_record?)
      self.email = auth['info']['email']
      self.first_name, self.last_name = auth['info']['name'].split(' ')
      self.last_name = auth['info']['last_name'] if(self.last_name.blank?)
    end
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'], :secret => auth['credentials']['secret'])
    self.save(:validate => false)
  end

  def update_wallet(commit_type, amount)
    if(commit_type == "Add")
      self.wallet += amount
    else
      self.wallet -= amount
    end
  end

  def has_pending_deals?
    unless(deals.not_completed.empty? && trips.not_completed.empty?)
      return false
    end
  end

  def activate!()
    self.activated = true
    places.each do |place|
      place.activate!()
    end
    self.save
  end

  def deactivate!
    self.activated = false
    places.each do |place|
      place.deactivate!()
    end
    self.save
  end


  def transfer_from_admin!(price)
    amount = Deal.subtract_brockerage_from_price(price)
    
    transfer(0, amount)
  end

  def transfer_to_admin!(price)
    amount = Deal.add_brockerage_to_price(price)
    
    transfer(1, amount)
  end

  private
    def transfer(code, amount)
      admin = User.admin.first
      
      ActiveRecord::Base.transaction do
        self.update_wallet(ARTH_OPERATION.key(1 - code), amount) 
        admin.update_wallet(ARTH_OPERATION.key(code), amount)
        admin.save
        self.save
      end
    end
end
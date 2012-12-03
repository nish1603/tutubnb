require "photovalidator"

class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :additional_guests, :additional_price, :daily_price, :monthly_price, :weekend_price, :weekly_price, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :description, :property_type, :title, :daily_price, :room_type, :presence => true
  validates :additional_price, :monthly_price, :weekend_price, :weekly_price, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true
  validates :additional_guests, :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }, :allow_nil => true
  validates :title, :uniqueness => { :case_sensitive => false, :scope => [:user_id] }, :unless => proc { |place| place.title.blank? }
  validates :daily_price, :numericality => { :greater_than_or_equal_to => 0}, :unless => proc{ |place| place.daily_price.blank? }
  validates_with PhotoValidator
  validate :check_tags

  PROPERTY_TYPE = {'Appartment' => 1, 'House' => 2, 'Castle' => 3, 'Villa' => 4, 'Cabin' => 5, 'Bed & Breakfast' => 6, 'Boat' => 7, 'Plane' => 8, 'Light House' => 9, 'Tree House' => 10, 'Earth House' => 11, 'Other' => 12}
  ROOM_TYPE = {'Private room' => 1, 'Shared room' => 2, 'Entire Home/apt' => 3}

  PLACE_TYPE = ['Activated', 'Deactivated']

  before_save :set_prices
  after_create :post_on_twitter
  before_destroy :check_current_deals
  
  has_one :detail, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_one :rules, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :deals, :dependent => :nullify
  has_many :reviews, :dependent => :destroy
  
  has_and_belongs_to_many :tags

  belongs_to :user

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :detail
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => lambda { |photo| photo[:avatar].blank? }
  accepts_nested_attributes_for :rules
  
  scope :by_location, lambda{ |type, location| joins(:address).where("addresses.#{type} LIKE ?", "%#{location}%") }
  scope :by_property, lambda{ |type, type_value| where(type => type_value) }
  scope :verified, lambda{ |flag| where(:verified => flag) }
  scope :hidden, lambda{ |flag| where(:hidden => flag) }

  def tags_string
    tags.map(&:tag).join(', ')
  end

  def tags_string=(string)
    place_tags = string.split(",").reject{ |tag| tag.blank? }
    self.tags = place_tags.map do |tag|
      Tag.find_or_initialize_by_tag(tag.strip)
    end
  end

  def set_prices()
    if(self.valid?)
      self.weekend_price = daily_price if weekend_price.nil?
      self.weekly_price = daily_price * 5 + weekend_price * 2 if weekly_price.nil? 
      self.monthly_price = daily_price * 30 if monthly_price.nil?
    end
  end

  def check_tags
    if(self.tags.length > 10)
      self.errors.add(:tags, "You can specify maximum 10 tags")
    end
  end

  def check_current_deals
    if(deals.not_completed.empty?)
      return true
    else
      return false
    end
  end

  
  def hide!()
    self.hidden = true
    self.save
  end

  def show!()
    self.hidden = false
    self.save
  end

  def property_type_string()
    PROPERTY_TYPE.key(property_type)
  end
  
  def room_type_string()
    ROOM_TYPE.key(room_type) 
  end
  
  def find_conflicting_deals(start_date, end_date)
    conflicting_deals = []
    
    place_deals = self.deals.state(1)
    dates = (start_date..end_date).to_a
    
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        conflicting_deals << place_deal
      end
    end

    return conflicting_deals
  end

  def reject_deals!(start_date, end_date)
    conflicting_deals = find_conflicting_deals(start_date, end_date)

    conflicting_deals.each do |place_deal|
      place_deal.state = 2
      place_deal.save
    end
  end

  def check_for_deals(start_date, end_date)
    if find_conflicting_deals(start_date, end_date).empty?
      return true
    else
      return false
    end
  end

  def activate!
    self.verified = true
    self.save
  end

  def deactivate!
    self.verified = false
    self.save
  end

  def post_on_twitter
    authentication = user.authentications.by_provider(:twitter)

    if(authentication)
      Twitter.configure do |config|
        config.consumer_key       = TWITTER_CONSUMER_TOKEN
        config.consumer_secret    = TWITTER_CONSUMER_SECRET
        config.oauth_token        = authentication.token
        config.oauth_token_secret = authentication.secret
      end
      Twitter.update title + " " + description 
    end
  end
end
require "photovalidator"

class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :additional_guests, :additional_price, :daily_price, :monthly_price, :weekend_price, :weekly_price, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :description, :property_type, :title, :daily_price, :room_type, presence: true
  validates :additional_guests, :additional_price, :monthly_price, :weekend_price, :weekly_price, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true
  validates :title, :uniqueness => { :case_sensitive => false, :scope => [:user_id] }, :unless => proc { |place| place.title.blank? }
  validates :daily_price, :numericality => { :greater_than_or_equal_to => 0}, :unless => proc{ |place| place.daily.blank? }
  validates_with PhotoValidator
  validate :check_tags

  PROPERTY_TYPE = {'Appartment' => 1, 'House' => 2, 'Castle' => 3, 'Villa' => 4, 'Cabin' => 5, 'Bed & Breakfast' => 6, 'Boat' => 7, 'Plane' => 8, 'Light House' => 9, 'Tree House' => 10, 'Earth House' => 11, 'Other' => 12}
  ROOM_TYPE = {'Private room' => 1, 'Shared room' => 2, 'Entire Home/apt' => 3}

  PLACE_TYPE = {'Activated' => 1, 'Deactivated' => 0}

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
  scope :state, lambda{ |flag| where(:verified => flag) }
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
      self.weekend = self.daily if self.weekend.nil?
      self.weekly = self.daily * 5 + self.weekend * 2 if weekly.nil? 
      self.monthly = self.daily * 30 if self.monthly.nil?
    end
  end

  def check_tags
    if(self.tags.length > 10)
      self.errors.add(:tags, "You can specify maximum 10 tags")
    end
  end

  def check_current_deals
    #FIXME_AB: deals.completed.empty?
    if(Deal.completed_by_place(self).empty?)
      return true
    else
      return false
    end
  end

  #FIXME_AB:  this is  a controller method
  def check_commit(commit_type)
    if(commit_type == "Save Place")
      validate = false
      self.hidden = true
      notice = "Your place has been saved. But it is hidden from the outside world."
    else
      validate = true
      notice = "Your place has been created."
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

  #FIXME_AB: this should be done in two parts. 1) find conflicting deals 2) loop them over and call reject!
  
  def find_conflicting_deals
    conflicting_deals = []
    place_deals = Deal.by_place(self).requested(true)
    dates = (start_date..end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        conflicting_deals << place_deal
      end
    end

    return conflicting_deals
  end

  def reject_deals(start_date, end_date)
    conflicting_deals = find_conflicting_deals

    conflicting_deals.each do |place_deal|
      place_deal.accept = false
      place_deal.request = false
      place_deal.save
    end
  end

  def check_for_deals(start_date, end_date)
    if find_conflicting_deals().empty?
      return true
    else
      return false
    end
  end

  #FIXME_AB: activate! and deactivate!
  def activate_or_deactivate_place(activate_type)
    if(activate_type == 'active')
      active = true
    else
      active = false
    end
    self.verified = active
  end

  def hide_or_show_place(operation_type)
    if(operation_type == 'hide')
      active = true
      result = "hidden"
    else
      active = false
      result = "visible"
    end
    
    self.hidden = active
    return result
  end

  def post_on_twitter
    client = Twitter::Client.new
    text = "Have a look on a new place #{self.title}"
    client.update(self.description)
  end
end
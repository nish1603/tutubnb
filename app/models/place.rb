require 'photovalidator'

class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :description, :property_type, :title, :daily, :room_type, presence: true
  validates :add_guests, :add_price, :monthly, :weekend, :weekly, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true
  validates :title, :uniqueness => { :case_sensitive => false, :scope => [:user_id] }, :unless => proc { |place| place.title.blank? }
  validates :daily, :numericality => { :greater_than_or_equal_to => 0}, :unless => proc{ |place| place.daily.blank? }
  validates_with PhotoValidator
  validate :check_tags

  PROPERTY_TYPE = {'Appartment' => 1, 'House' => 2, 'Castle' => 3, 'Villa' => 4, 'Cabin' => 5, 'Bed & Breakfast' => 6, 'Boat' => 7, 'Plane' => 8, 'Light House' => 9, 'Tree House' => 10, 'Earth House' => 11, 'Other' => 12}
  ROOM_TYPE = {'Private room' => 1, 'Shared room' => 2, 'Entire Home/apt' => 3}
  PLACE_TYPE = ['Activated', 'Deactivated']

  before_save :set_prices
  before_destroy :check_current_deals
  
  has_one :detail, :dependent => :delete
  has_one :address, :dependent => :delete
  has_one :rules, :dependent => :delete
  has_many :photos, :dependent => :delete_all, :inverse_of => :place
  has_many :deals, :dependent => :nullify
  has_many :reviews, :dependent => :delete_all
  
  has_and_belongs_to_many :tags

  belongs_to :user

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :detail
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => lambda { |photo| photo[:avatar].blank? }
  accepts_nested_attributes_for :rules


  scope :by_location, lambda{ |type, location| joins(:address).where("addresses.#{type} LIKE ?", "%#{location}%") }
  scope :by_property, lambda{ |type, type_value| where(type => type_value) }
  scope :visible, lambda{ |flag| where(:verified => flag) }
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
    if(Deal.completed_by_place(self).empty?)
      return true
    else
      return false
    end
  end

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

  def property_type_string()
    PROPERTY_TYPE.key(property_type)
  end
  
  def room_type_string()
    ROOM_TYPE.key(room_type) 
  end

  def reject_deals(start_date, end_date)
    place_deals = Deal.by_place(self).requested(true)
    dates = (start_date..end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        place_deal.accept = false
        place_deal.request = false
        place_deal.save
      end
    end
  end

  def check_for_deals(start_date, end_date)
    place_deals = Deal.by_place(self).accepted(true)
    dates = (start_date..end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        return false
      end
    end
    return true
  end

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
end
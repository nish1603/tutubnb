class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :title, :description, :property_type, :room_type, :daily, presence: true
  validates :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true
  validates :title, :uniqueness => { :scope => [:user_id] }

  PROPERTY_TYPE = ['Appartment', 'House', 'Castle', 'Villa', 'Cabin', 'Bed & Breakfast', 'Boat', 'Plane', 'Light House', 'Tree House', 'Earth House', 'Other']
  ROOM_TYPE = ['Private room', 'Shared room', 'Entire Home/apt']
  PLACE_TYPE = ['Activated', 'Deactivated']

  before_save :set_prices
  before_update :set_prices
  
  has_one :detail, :dependent => :delete
  has_one :address, :dependent => :delete
  has_one :rules, :dependent => :delete
  has_many :photos, :dependent => :delete_all
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
  scope :admin_visible, where(:hidden => false)

  def tags_string
    tags.map(&:tag).join(', ')
  end

  def tags_string=(string)
    place_tags = string.split(", ").reject{ |tag| tag.nil? or tag.blank? }
    self.tags = place_tags.map do |tag|
      Tag.find_or_initialize_by_tag(tag.strip)
    end
  end

  def set_prices
    if(self.valid?)
      self.weekend = self.daily if self.weekend.nil?
      self.weekly = self.daily * 5 + self.weekend * 2 if self.weekly.nil? 
      self.monthly = self.daily * 30 if self.monthly.nil?
    end
  end
end
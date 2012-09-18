class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes, :photos_attributes, :rules_attributes, :tags_string
  
  validates :title, :description, :property_type, :room_type, :daily, presence: true
  validates :add_guests, :add_price, :daily, :monthly, :weekend, :weekly, :numericality => { :greater_than_or_equal_to => 0}, :allow_nil => true

  PROPERTY_TYPE = ['Appartment', 'House', 'Castle', 'Villa', 'Cabin', 'Bed & Breakfast', 'Boat', 'Plane', 'Light House', 'Tree House', 'Earth House', 'Other']
  ROOM_TYPE = ['Private room', 'Shared room', 'Entire Home/apt']
  PLACE_TYPE = ['Activated', 'Deactivated']

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
  accepts_nested_attributes_for :photos, :allow_destroy => true
  accepts_nested_attributes_for :rules


  scope :by_city, lambda{ |city| joins(:address).where('addresses.city = ?', city) }
  scope :by_country, lambda{ |country| joins(:address).where('addresses.country = ?', country) }
  scope :by_property_type, lambda{ |property_type| where(:property_type => property_type) }
  scope :by_room_type, lambda{ |room_type| where(:room_type => room_type) }
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

  private
    def require_two_photos
      errors.add(:base, "You must provide at least two photos") if self.photos.count < 2
    end
end
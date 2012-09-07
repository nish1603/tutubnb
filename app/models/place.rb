class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :max_guests, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes, :photos_attributes
  
  validates :title, :description, :property_type, :room_type, presence: true

  PROPERTY_TYPE = ['Appartment', 'House', 'Castle', 'Villa', 'Cabin', 'Bed & Breakfast', 'Boat', 'Plane', 'Light House', 'Tree House', 'Earth House', 'Other']
  ROOM_TYPE = ['Private room', 'Shared room', 'Entire Home/apt']

  has_one :detail, :dependent => :delete
  has_one :address, :dependent => :delete
  has_many :photos, :dependent => :delete_all
  has_many :deals
  has_many :reviews, :dependent => :delete_all

  belongs_to :user

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :detail
  accepts_nested_attributes_for :photos

  validate :require_two_photos

  scope :by_city, lambda{ |city| joins(:address).where('addresses.city = ?', city) }
  scope :by_country, lambda{ |country| joins(:address).where('addresses.country = ?', country) }
  scope :by_property_type, lambda{ |property_type| where(:property_type => property_type) }
  scope :by_room_type, lambda{ |room_type| where(:room_type => room_type) }
  scope :by_accomodates, lambda{ |accomodates| joins(:detail).where('detail.accomodates = ?', accomodates) }

  private
    def require_two_photos
      errors.add(:base, "You must provide at least two photos") if photos.count < 2
    end
end
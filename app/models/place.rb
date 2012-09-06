class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title, :add_guests, :add_price, :daily, :max_guests, :monthly, :weekend, :weekly, :place_id, :address_attributes, :detail_attributes
  
  validates :title, :description, :property_type, :room_type, presence: true

  PROPERTY_TYPE = ['Appartment', 'House', 'Castle', 'Villa', 'Cabin', 'Bed & Breakfast', 'Boat', 'Plane', 'Light House', 'Tree House', 'Earth House', 'Other']
  ROOM_TYPE = ['Private room', 'Shared room', 'Entire Home/apt']

  has_one :price, :dependent => :delete
  has_one :detail, :dependent => :delete
  has_one :address, :dependent => :delete
  has_many :photos, :dependent => :delete_all
  has_many :deals

  belongs_to :user

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :detail

  def self.find_by_location(location) #in one query
  	addresses = Address.find_by_location(location)
  	result = []

  	addresses.each do |address|
  	  result << address.place unless address.place.nil?
    end
    result
  end

end
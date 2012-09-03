class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title
  has_one :price
  has_one :detail
  has_one :address
  has_many :photos
  has_many :deals

  belongs_to :user

  def self.find_by_location(location)
  	addresses = Address.find_by_location(location)
  	result = []

  	addresses.each do |address|
  	  result << address.place unless address.place.nil?
    end
    result
  end

end
class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :pincode, :state, :place_id

  belongs_to :place

  def self.find_by_location(location)
  	Address.where(:city => location)
  end
end

class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :pincode, :state, :place_id, :latitude, :longitude, :gmaps
  validates :address_line1, :city, :state, :country, :pincode, :presence => true
  validates :pincode, :numericality => true
  validates :city, :country, :state, :format => { :with => /^[a-zA-Z\s\.]+$/ }
  validates :address_line1, :uniqueness => { :scope => [:address_line2, :city, :state, :pincode, :country] }

  belongs_to :place

  acts_as_gmappable :lat => "latitude", :lng => "longitude", :check_process => false

  def gmaps4rails_address
    "#{self.address_line1}, #{self.address_line2}, #{self.city}, #{self.state}, #{self.pincode}, #{self.country}" 
  end
end

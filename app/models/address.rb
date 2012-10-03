class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :pincode, :state, :latitude, :longitude, :gmaps
  
  validates :address_line1, :city, :state, :country, :pincode, :presence => true
  validates :pincode, :numericality => { :only_integer => true }, :unless => proc { |address| address.pincode.blank? }
  validates :city, :format => { :with => /^[a-zA-Z\s\.]+$/ }, :unless => proc { |address| address.city.blank? }
  validates :country, :format => { :with => /^[a-zA-Z\s\.]+$/ }, :unless => proc { |address| address.country.blank? }
  validates :state, :format => { :with => /^[a-zA-Z\s\.]+$/ }, :unless => proc { |address| address.state.blank? }
  validates :address_line1, :uniqueness => { :scope => [:address_line2, :city, :state, :pincode, :country], :message => "is already taken." }, :unless => proc { |address| address.address_line1.blank? }

  belongs_to :place

  acts_as_gmappable :lat => "latitude", :lng => "longitude", :check_process => false

  def gmaps4rails_address
    "#{self.address_line1}, #{self.address_line2}, #{self.city}, #{self.state}, #{self.pincode}, #{self.country}" 
  end
end
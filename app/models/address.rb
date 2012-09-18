class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :pincode, :state, :place_id
  validates :address_line1, :address_line2, :city, :state, :country, :pincode, :presence => true
  validates :pincode, :numericality => true
  validates :city, :country, :state, :format => { :with => /^[a-zA-Z\s\.]+$/ }
  validates :address_line1, :uniqueness => { :scope => [:address_line2, :city, :state, :pincode, :country] }

  belongs_to :place

  #scope :a_city, lambda { |city| where(:city => city) }
end

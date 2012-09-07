class Address < ActiveRecord::Base
  attr_accessible :address_line1, :address_line2, :city, :country, :pincode, :state, :place_id

  validates :address_line1, :address_line2, :city, :state, :country, :pincode, presence: true

  belongs_to :place

  scope :a_city, lambda { |city| where(:city => city) }
end

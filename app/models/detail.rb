class Detail < ActiveRecord::Base
  attr_accessible :accomodation, :bathrooms, :bed_type, :bedrooms, :beds, :pets, :size, :unit, :place_id
  belongs_to :place

  validates :accomodation, :presence => true
  validates :accomodation, :bathrooms, :bedrooms, :beds, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true

  UNITS = ["sq. meters", "sq. feets"]

  #Guests = (1..16).to_a << 25 << 50 << 75 << 100 << "100+"
end

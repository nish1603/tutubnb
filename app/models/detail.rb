class Detail < ActiveRecord::Base
  attr_accessible :accomodation, :bathrooms, :bed_type, :bedrooms, :beds, :pets, :size, :unit, :place_id
  belongs_to :place

  Guests = (1..16).to_a << 25 << 50 << 75 << 100 << "100+"
end

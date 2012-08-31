class Detail < ActiveRecord::Base
  attr_accessible :accomodation, :bathrooms, :bed_type, :bedrooms, :beds, :pets, :size, :unit, :place_id
  belongs_to :place
end

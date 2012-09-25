class Detail < ActiveRecord::Base
  attr_accessible :accomodation, :bathrooms, :bed_type, :bedrooms, :beds, :pets, :size, :unit, :place_id
  belongs_to :place

  validates :accomodation, :presence => true
  validates :accomodation, :bathrooms, :bedrooms, :beds, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true

  #UNITS = {"sq. meters" => 1, "sq. feets" => 2}
  UNITS = ["sq. meters", "sq. feets"]

  # def unit_string
  # 	UNITS.key(unit) 
  # end

  # def unit_string=(string)
  # 	UNITS[string]
  # end 
end
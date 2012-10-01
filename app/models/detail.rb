class Detail < ActiveRecord::Base
  attr_accessible :accomodation, :bathrooms, :bed_type, :bedrooms, :beds, :pets, :size, :unit, :place_id
  belongs_to :place

  validates :accomodation, :presence => true
  validates :accomodation, :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }, :unless => lambda{ |detail| detail.accomodation.blank? }
  validates :bathrooms, :bedrooms, :beds, :numericality => { :greater_than_or_equal_to => 0, :only_integer => true }, :allow_nil => true

  UNITS = {"sq. meters" => 1, "sq. feets" => 2}

  def units_string
  	Detail::UNITS.key(unit)
  end
end
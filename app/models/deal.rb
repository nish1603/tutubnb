class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests

  belongs_to :user
  belongs_to :place

  def self.find_listings(places)
  	result = []
  	places.each do |place|
  	  temp = Deal.find_all_by_place_id(place.id)
      result << temp unless temp.nil?
    end
    result = result.flatten
    result = nil if result.empty?
    result
  end

   def self.find_listings(places)
    result = []
    places.each do |place|
      temp = Deal.find_all_by_place_id(place.id)
      result << temp unless temp.nil?
    end
    result.flatten
  end

end

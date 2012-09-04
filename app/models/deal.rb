class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests

  belongs_to :user
  belongs_to :place

  def self.find_listings(places)
    result = []
    places.each do |place|
      temp = Deal.where(:request => false, :place_id => place.id)
      result << temp unless temp.nil?
    end
    result.flatten
  end

  def self.find_trips(user_id)
    Deal.find_all_by_user_id(user_id) || []
  end

  def self.find_requests(places)
    result = []
    places.each do |place|
      temp = Deal.where(:request => true, :place_id => place.id)
      result << temp unless temp.nil?
    end
    result.flatten
  end
  

end

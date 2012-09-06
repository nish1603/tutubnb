class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests, :cancel, :accept, :request

  belongs_to :user
  belongs_to :place

  scope :canceled, lambda { |flag| where(cancel: flag) }
  scope :requested, lambda { |flag| where(request: flag) }
  scope :accepted, lambda { |flag| where(accept: flag) }
  scope :requests, lambda { |user| user.deals.requested(false).canceled(false) }
  scope :find_visits_of_user, lambda { |user| user.deals.accepted(true).canceled(false) }
  scope :find_requests_of_user, lambda { |user| user.deals.requested(false).canceled(false) }
  scope :find_trips_of_user, lambda { |user| user.deals.requested(false).canceled(false) }
  

  # def self.find_listings(places)
  #   result = []
  #   places.each do |place|
  #     temp = Deal.where(:request => false, :place_id => place.id)
  #     result << temp unless temp.nil?
  #   end
  #   result.flatten
  # end

  # def self.find_trips(user_id)
  #   Deal.find_all_by_user_id(user_id) || []
  # end

  # def self.find_requests(places)
  #   result = []
  #   places.each do |place|
  #     temp = Deal.where(:request => true, :place_id => place.id)
  #     result << temp unless temp.nil?
  #   end
  #   result.flatten
  # end
  

end

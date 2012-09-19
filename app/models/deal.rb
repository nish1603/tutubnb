class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests, :cancel, :accept, :request
  
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :guests, :presence => true, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }
  validate :user_have_amount
  validate :user_have_wallet
  
  TYPE = ['Accepted', 'Rejected', 'Requests', 'To Complete', 'Completed']

  belongs_to :user
  belongs_to :place

  scope :canceled, lambda { |flag| where(cancel: flag) }
  scope :requested, lambda { |flag| where(request: flag) }
  scope :accepted, lambda { |flag| where(accept: flag) }
  scope :requests, lambda { |user| user.deals.requested(false).canceled(false) }
  scope :find_visits_of_user, lambda { |user| user.deals.accepted(true).canceled(false) }
  scope :find_requests_of_user, lambda { |user| user.deals.requested(true).canceled(false) }
  scope :find_trips_of_user, lambda { |user| user.trips.requested(false).canceled(false) }
  scope :find_requested_trips_of_user, lambda { |user| user.trips.requested(true).canceled(false) }
  scope :to_complete, lambda { |flag| where(:complete => flag, :request => false) }
  scope :completed, lambda { |flag| where(:complete => flag) }
  scope :by_place, lambda { |place| where(:place_id => place.id)}
  
  private
    def user_have_amount
      if(self.user.wallet < (price*1.1))
        errors.add(:base, "Sorry, You don't have enough amount to pay in your wallet.")
      end
    end

    def user_have_wallet
      amount = self.user.trips.requested(true).sum(:price)
      amount = amount + self.price
      if(self.user.wallet < (amount*1.1))
        errors.add(:base, "Sorry, You have requested places upto the limit of your wallet.")
      end
    end
end

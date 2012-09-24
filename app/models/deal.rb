class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests, :cancel, :accept, :request
  
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :guests, :presence => true, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }
  
  before_save :user_have_amount
  before_save :user_have_wallet
  
  validate :valid_start_date
  validate :valid_end_date
  validate :less_than_max_guests

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
        return false
      end
    end

    def user_have_wallet
      amount = self.user.trips.requested(true).sum(:price)
      amount = amount + self.price
      if(self.user.wallet < (amount*1.1))
        errors.add(:base, "Sorry, You have requested places upto the limit of your wallet.")
        return false
      end
    end

    def valid_start_date
      if(start_date.nil? || start_date < Date.current)
        errors.add(:base, "Start date should be more than or equal to current date.")
      end
    end

    def valid_end_date
      if(end_date.nil? || end_date < start_date)
        errors.add(:base, "End date should be more than or equal to Start date.")
      end
    end

    def less_than_max_guests
      max_guests = self.place.detail.accomodation
      if(max_guests < self.guests.to_i)
        errors.add(:base, "Guests can't be more than #{max_guests}")
      end
    end
end
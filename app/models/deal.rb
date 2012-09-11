class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests, :cancel, :accept, :request
  
  validates :end_date, :price, :start_date, :guests, :presence => true
  # validates :dates_valid, :on_or_after => lambda{ Date.current }
  # validates :end_date, :after => lambda{ start_date + 1 }
  validate :user_have_amount

  belongs_to :user
  belongs_to :place

  scope :canceled, lambda { |flag| where(cancel: flag) }
  scope :requested, lambda { |flag| where(request: flag) }
  scope :accepted, lambda { |flag| where(accept: flag) }
  scope :requests, lambda { |user| user.deals.requested(false).canceled(false) }
  scope :find_visits_of_user, lambda { |user| user.deals.accepted(true).canceled(false) }
  scope :find_requests_of_user, lambda { |user| user.deals.requested(true).canceled(false) }
  scope :find_trips_of_user, lambda { |user| user.deals.requested(false).canceled(false) }

  private
    def user_have_amount
      if(self.user.wallet < price)
        errors.add("Sorry, You don't have enough amount to pay in your wallet.")
    end  
end

require 'datefunctions'

class Deal < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :guests

  attr_accessor :days, :weeks, :months, :years, :weekdays, :weekends, :division
  
  validates :price, :guests, :start_date, :end_date, :presence => true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }, :unless => proc { |deal| deal.price.blank? }
  validates :guests, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }, :unless => proc { |deal| deal.guests.blank? }
  validates :place_id, :presence => { :message => "can't be blank" }
  validates :user_id, :presence => { :message => "can't be blank" }
  
  validate :validate_start_date, :unless => proc { |deal| deal.start_date.blank? }
  validate :validate_end_date, :unless => proc { |deal| deal.end_date.blank? }
  validate :less_than_max_guests, :unless => proc { |deal| deal.guests.blank? }

  #FIXME_AB: These should be validation.
  before_create :user_have_amount
  before_create :user_have_wallet
  before_create :place_already_book

  TYPE = {'Accepted' => 1, 'Rejected' => 2, 'Requests' => 0, 'To Complete' => 3, 'Completed' => 4, 'Reviewed' => 5}

  belongs_to :user
  belongs_to :place

  scope :state, lambda { |state_value| where(state: state_value) }
  
  #FIXME_AB: deals.conditions etc.. user_id = user.id . Check if join query is fired 
  # scope :requests, lambda { |user| user.deals.requested(false).canceled(false) }

  scope :find_visits_of_user, lambda { |user| user.deals.accepted(true).canceled(false) }
  scope :find_requests_of_user, lambda { |user| user.deals.requested(true).canceled(false) }
  scope :find_trips_of_user, lambda { |user| user.trips.requested(false).canceled(false) }
  scope :find_requested_trips_of_user, lambda { |user| user.trips.requested(true).canceled(false) }
  
  #FIXME_AB: I doubt if we need following as scope
  scope :completed_by_place, lambda { |place| Deal.where(:place_id => place.id).completed(false).requested(true) }
  scope :unreviewed_by_user_on_place, lambda { |user, place| Deal.where(:place_id => place.id, :user_id => user.id).completed(true).reviewed(false) } 

    def owner
      place.user
    end

    def add_brockerage_to_price(price)
      price * 1.1
    end

    def subtract_brockerage_from_price(price)
      price * 0.9
    end

    def user_have_amount
      if(user.wallet < (add_brockerage_to_price(price)))
        errors.add(:base, "Sorry, You don't have enough amount to pay in your wallet.")
        return false
      end
    end

    def user_have_wallet
      amount = self.user.trips.requested(true).sum(:price)
      amount = amount + self.price
      if(self.user.wallet < (add_brockerage_to_price(amount)))
        errors.add(:base, "Sorry, You have requested places upto the limit of your wallet.")
        return false
      end
    end

    def valid_start_date
      if(start_date.nil? || start_date < Date.current)
        errors.add(:start_date, "should be more than or equal to current date")
        return false
      end
    end

    def valid_end_date
      if(end_date.nil? || end_date < start_date)
        errors.add(:end_date, "should be more than or equal to start date")
        return false
      end
    end

    def less_than_max_guests
      max_guests = self.place.detail.accomodation
      if(max_guests < self.guests.to_i)
        errors.add(:guests, "can't be more than #{max_guests}")
        return false
      end
    end
    
    def calculate_price()
      self.price = 0.0
      self.months, self.weeks, self.days = start_date.calculate_days_weeks_months(end_date)
      self.weekdays, self.weekends = start_date.calculate_weekdays_weekends(days)

      self.price += weeks * place.weekly_price
      self.price += months * place.monthly_price
      self.price += weekends * place.weekend_price
      self.price += weekdays * place.daily_price
      self.price += calculate_price_for_add_guests()
    end
    
    def calculate_price_for_add_guests()
      if(place.add_guests && guests >= place.add_guests)
        return (guests - place.add_guests) * place.add_price
      end
      return 0
    end

    #FIXME_AB: Create two method accept! or reject!
    def reply_to_deal(perform)
      self.request = false

      if(perform == "accept")
        res = true
        user.transfer_to_admin(price)
        user.save
        place.reject_deals(start_date, end_date)
      else
        res = false
      end
      self.accept = res
    end

    #FIXME_AB: naming issues. mark_complete!
    def completion_of_deal()
      complete = true
      owner.transfer_from_admin!(price)
    end

    
    def place_already_book()
      available = self.place.check_for_deals(self.start_date, self.end_date)
      self.errors.add(:base, "Sorry, this place is already booked for these dates") if(available == false)
      return available
    end
end
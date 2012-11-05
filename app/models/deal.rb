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
  before_save :user_have_amount
  before_save :user_have_wallet
  before_save :place_already_book
  
  TYPE = {'Accepted' => 1, 'Rejected' => 2, 'Requests' => 0, 'To Complete' => 3, 'Completed' => 4, 'Reviewed' => 5}

  belongs_to :user
  belongs_to :place

  scope :state, lambda { |value| where(:state => value) }
  scope :not_completed, where("state = ? OR state = ?", 1, 3)

  scope :find_visits_of_user, lambda { |user| user.deals.state(1) }
  scope :find_requests_of_user, lambda { |user| user.deals.state(0) }
  scope :find_trips_of_user, lambda { |user| user.trips.where("state != ?", 0) }
  scope :find_requested_trips_of_user, lambda { |user| user.trips.state(0) }
  
  #FIXME_AB: I doubt if we need following as scope
  scope :completed_by_place, lambda { |place| Deal.where(:place_id => place.id).completed(false).requested(true) }
  scope :unreviewed_by_user_on_place, lambda { |user, place| Deal.where(:place_id => place.id, :user_id => user.id).status(4) } 

    def owner
      place.user
    end

    def self.add_brockerage_to_price(price)
      return (price * 1.1)
    end

    def self.subtract_brockerage_from_price(price)
      return (price * 0.9)
    end

    def user_have_amount
      if(user.wallet < (add_brockerage_to_price(price)))
        errors.add(:base, "Sorry, You don't have enough amount to pay in your wallet.")
        return false
      end
      return  true
    end

    def user_have_wallet
      amount = user.trips.state(0).sum(:price)
      amount = amount + price
      if(user.wallet < (add_brockerage_to_price(amount)))
        errors.add(:base, "Sorry, You have requested places upto the limit of your wallet.")
        return false
      end
      return true
    end

    def validate_start_date
      if(start_date.nil? || start_date < Date.current)
        errors.add(:start_date, "should be more than or equal to current date")
      end
    end

    def validate_end_date
      if(end_date.nil? || end_date < start_date)
        errors.add(:end_date, "should be more than or equal to start date")
      end
    end

    def less_than_max_guests
      max_guests = self.place.detail.accomodation
      if(max_guests < self.guests.to_i)
        errors.add(:guests, "can't be more than #{max_guests}")
      end
    end
    
    def calculate_price()
      self.price = 0.0
      self.months, self.weeks, self.days = start_date.calculate_days_weeks_months(end_date)
      self.weekdays, self.weekends = start_date.calculate_weekdays_weekends(days)

      self.price = set_price(price)
    end

    def set_price(price)
      price += weeks * place.weekly_price
      price += months * place.monthly_price
      price += weekends * place.weekend_price
      price += weekdays * place.daily_price
      price += calculate_price_for_additional_guests()
      price
    end

    def calculate_price_for_additional_guests()
      if(place.additional_guests && guests >= place.additional_guests)
        return (guests - place.additional_guests) * place.additional_price
      end
      return 0
    end

    def accept!()
      self.state = 1
      user.transfer_to_admin!(price)
      place.reject_deals!(start_date, end_date)
      self.save
    end

    def reject!()
      self.state = 2
      self.save
    end

    def mark_completed!()
      self.state = 4
      owner.transfer_from_admin!(price)
    end
    
    def place_already_book()
      available = place.check_for_deals(start_date, end_date)
      errors.add(:base, "Sorry, this place is already booked for these dates") if(available == false)
      return available
    end
end
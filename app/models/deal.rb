class Deal < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :guests

  attr_accessor :days, :weeks, :months, :years, :weekdays, :weekends, :division
  
  validates :price, :presence => true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }, :unless => proc { |deal| deal.price.blank? }
  validates :guests, :presence => true
  validates :guests, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }, :unless => proc { |deal| deal.guests.blank? }
  
  before_create :user_have_amount
  before_create :user_have_wallet
  before_create :place_already_book
  
  validate :valid_start_date
  validate :valid_end_date
  validate :less_than_max_guests

  TYPE = ['Accepted', 'Rejected', 'Requests', 'To Complete', 'Completed']

  belongs_to :user
  belongs_to :place

  scope :canceled, lambda { |flag| where(cancel: flag) }
  scope :requested, lambda { |flag| where(request: flag) }
  scope :accepted, lambda { |flag| where(accept: flag) }
  scope :reviewed, lambda { |flag| where(review: flag) }
  scope :requests, lambda { |user| user.deals.requested(false).canceled(false) }
  scope :find_visits_of_user, lambda { |user| user.deals.accepted(true).canceled(false) }
  scope :find_requests_of_user, lambda { |user| user.deals.requested(true).canceled(false) }
  scope :find_trips_of_user, lambda { |user| user.trips.requested(false).canceled(false) }
  scope :find_requested_trips_of_user, lambda { |user| user.trips.requested(true).canceled(false) }
  scope :to_complete, lambda { |flag| where(:complete => flag, :request => false) }
  scope :completed, lambda { |flag| where(:complete => flag) }
  scope :by_place, lambda { |place| where(:place_id => place.id)}
  scope :completed_by_place, lambda { |place| Deal.where(:place_id => place.id).completed(false).requested(true) }
  scope :unreviewed_by_user_on_place, lambda { |user, place| Deal.where(:place_id => place.id, :user_id => user.id).completed(true).reviewed(false) } 

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

    
    def calculate_price()
      self.price = 0.0
      calculate_days_weeks_months()
      calculate_weekdays_weekends()

      self.price += self.weeks * self.place.weekly
      self.price += self.months * self.place.monthly
      self.price += (self.weekends * self.place.weekend)
      self.price += (self.weekdays * self.place.daily)
      self.price += calculate_price_for_add_guests()

      return create_divisions()
    end


    def calculate_days_weeks_months()
      self.days = self.end_date.day - self.start_date.day
      self.months = self.end_date.month - self.start_date.month
      self.years = self.end_date.year - self.start_date.year

      adjust_days_weeks_months()

      self.months += self.years * 12

      self.weeks = (self.days + 1) / 7
      self.days = (self.days + 1) % 7
    end

    def adjust_days_weeks_months()
      if(self.end_date.month < (self.start_date.month))
        self.years -= 1
        self.months = (12 - self.start_date.month) + self.end_date.month
      end

      if(self.end_date.day < (self.start_date.day-1))
        self.months -= 1 
        self.days = self.start_date.end_of_month.day - self.start_date.day
        self.days += self.end_date.day
      end
    end

    def calculate_weekdays_weekends()
      self.weekdays = 0
      self.weekends = 0

      (self.start_date...(self.start_date+self.days)).to_a.each do |date|
        if(date.sunday? or date.saturday?)
          self.weekends += 1
        else
          self.weekdays += 1
        end
      end
    end

    def calculate_price_for_add_guests()
      if(self.place.add_guests and self.guests >= self.place.add_guests)
        return (self.guests - self.place.add_guests) * self.place.add_price
      end
      return 0
    end

    def create_divisions()
      self.division = []
      self.division << "No. of Months : #{self.months}, Price : #{self.months}x#{self.place.monthly} \n" if(self.months > 0)
      self.division << "No. of Weeks : #{self.weeks}, Price : #{self.weeks}x#{self.place.weekly} \n" if(self.weeks > 0)
      self.division << "No. of Weekdays : #{self.weekdays}, Price : #{self.weekdays}x#{self.place.daily} \n" if(self.weekdays > 0)
      self.division << "No. of Weekends : #{self.weekends}, Price : #{self.weekends}x#{self.place.weekend} \n" if(self.weekends > 0)
      self.division << "Additional guests : #{self.place.add_guests}, Price : #{self.place.add_guests}x#{self.place.add_price}" if(self.place.add_guests and self.guests >= self.place.add_guests)
      self.division << "Total Amount : #{self.price.round(2)} + 10% Service Charge : #{(0.1 * self.price).round(2)}"
      return self.division
    end

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

    def completion_of_deal()
      self.complete = true
      self.place.user.transfer_from_admin(price)
      self.place.user.save
    end

    def place_already_book()
      available = self.place.check_for_deals(self.start_date, self.end_date)
      self.errors.add(:base, "Sorry, this place is already booked for these dates") if(available == false)
      return available
    end
end
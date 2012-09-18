module DealHelper
	def self.calculate_price(deal, place)
    
    days, weeks, months = calculate_days(deal)

    amount, weekdays, weekends = calculate_price(days, weeks, months, deal, price)

    
    msg = []
    msg << "No. of Months : #{months}, Price : #{months}x#{place.monthly} \n" if(months > 0)
    msg << "No. of Weeks : #{weeks}, Price : #{weeks}x#{place.weekly} \n" if(weeks > 0)
    msg << "No. of Weekdays : #{weekdays}, Price : #{weekdays}x#{place.daily} \n" if(weekdays > 0)
    msg << "No. of Weekends : #{weekends}, Price : #{weekends}x#{place.weekend} \n" if(weekends > 0)
    msg << "Total Amount : #{amount.round(2)} + 10% Service Charge : #{(0.1 * amount).round(2)}"
    return amount, msg
  end

  def self.calculate_days(deal)
    days = deal.end_date.day - deal.start_date.day
    months = deal.end_date.month - deal.start_date.month
    years = deal.end_date.year - deal.start_date.year
    
    if(deal.end_date.day < (deal.start_date.day-1))
      months -= 1 
      days = deal.start_date.end_of_month.day - deal.start_date.day
      days += deal.end_date.day
    end

    if(deal.end_date.month < (deal.start_date.month-1))
      years -= 1
      months = (12 - deal.end_date.months) + deal.start_date.months
    end
    months += years * 12

    return days, weeks, months
  end

  def self.calculate_price(days, weeks, months, deal, place)
    amount = 0.0
    weekdays = 0
    weekends = 0

    weeks = (days + 1) / 7
    days = (days + 1) % 7
    
    amount += weeks * place.weekly
    amount += months * place.monthly

    (deal.start_date...(deal.start_date+days)).to_a.each do |date|
      if(date.sunday? or date.saturday?)
        amount += place.weekend
        weekends += 1
      else
        amount += place.daily
        weekdays += 1
      end
    end

    if(place.add_guests and deal.guests >= place.add_guests)
      amount += (deal.guests - place.add_guests) * place.add_price
    end

    return amount, weekdays, weekends
  end

  def self.check_deal(deal, place)
    event_validate, key, msg = check_accomodate(deal, place)
    event_validate, key, msg = check_dates(deal, place) if event_validate
    
    return check_place(deal, place) if event_validate
    return event_validate, key, msg
  end

  def self.check_accomodate(deal, place)
    if(deal.guests and deal.guests > place.detail.accomodation)
      return false, :alert, "Sorry, Maximum Accomodation for this space is #{place.details.accomodation}"
    else
      return true
    end
  end

  def self.check_dates(deal, place)
    if(deal.start_date and deal.start_date < Date.current)
      return false, :error, "You can't register a past event"
    elsif(deal.end_date and deal.end_date < deal.start_date)
      return false, :error, "End date should be more than with Start date"
    else
      return true
    end
  end

  def self.check_place(deal, place)
    place_deals = Deal.by_place(place).accepted(true)
    dates = (deal.start_date..deal.end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        return false, :alert, "Sorry, the place is already booked for these dates"
      end
    end
    return true
  end

  def self.reject_deals(deal, place)
    place_deals = Deal.by_place(place).requested(true)
    dates = (deal.start_date..deal.end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        place_deal.accept = false
        place_deal.request = false
        place_deal.save
      end
    end
  end
end
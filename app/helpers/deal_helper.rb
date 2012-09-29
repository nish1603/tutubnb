module DealHelper
	
  def self.calculate_price(deal, place)
    
    days, weeks, months = calculate_days_weeks_months(deal.start_date, deal.end_date)
    amount, weekdays, weekends = calculate_amount(days, weeks, months, deal.guests, place)
    
    
    msg = []
    msg << "No. of Months : #{months}, Price : #{months}x#{place.monthly} \n" if(months > 0)
    msg << "No. of Weeks : #{weeks}, Price : #{weeks}x#{place.weekly} \n" if(weeks > 0)
    msg << "No. of Weekdays : #{weekdays}, Price : #{weekdays}x#{place.daily} \n" if(weekdays > 0)
    msg << "No. of Weekends : #{weekends}, Price : #{weekends}x#{place.weekend} \n" if(weekends > 0)
    msg << "Additional guests : #{place.add_guests}, Price : #{place.add_guests}x#{place.add_price}" if(place.add_guests and deal.guests >= place.add_guests)
    msg << "Total Amount : #{amount.round(2)} + 10% Service Charge : #{(0.1 * amount).round(2)}"
    return amount, msg
  end

  def self.calculate_days_weeks_months(start_date, end_date)
    days = end_date.day - start_date.day
    months = end_date.month - start_date.month
    years = end_date.year - start_date.year

    if(end_date.month < (start_date.month))
      years -= 1
      months = (12 - start_date.month) + end_date.month
    end

    if(end_date.day < (start_date.day-1))
      months -= 1 
      days = start_date.end_of_month.day - start_date.day
      days += end_date.day
    end

    months += years * 12

    weeks = (days + 1) / 7
    days = (days + 1) % 7
    
    return days, weeks, months
  end

  def self.calculate_amount(days, weeks, months, place)
    amount = 0.0
    weekdays = 0
    weekends = 0

    amount += weeks * place.weekly
    amount += months * place.monthly

    (deal.start_date...(deal.start_date+days)).to_a.each do |date|
      if(date.sunday? or date.saturday?)
        weekends += 1
      else
        weekdays += 1
      end
    end

    amount += (weekends * place.weekend)
    amount += (weekdays * place.daily)

    if(place.add_guests and guests >= place.add_guests)
      amount += (guests - place.add_guests) * place.add_price
    end
    return amount, weekdays, weekends

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

  def self.transer_from_admin(deal)
    admin = User.admin.first  
    owner = deal.place.user

    admin.wallet -= (deal.price * 0.9)
    owner.wallet += (deal.price * 0.9)
    return admin, owner
  end

  def self.transfer_to_admin(deal)
    requestor = deal.user
    admin = User.admin.first

    requestor.wallet -= (deal.price * 1.1) 
    admin.wallet += (deal.price * 1.1)

    return admin, requestor
  end
end
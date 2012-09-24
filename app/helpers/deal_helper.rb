module DealHelper
	
  def self.calculate_price(deal, place)
    amount = 0.0
    weekdays = 0
    weekends = 0
    days = deal.end_date.day - deal.start_date.day
    months = deal.end_date.month - deal.start_date.month
    years = deal.end_date.year - deal.start_date.year

    if(deal.end_date.month < (deal.start_date.month))
      years -= 1
      months = (12 - deal.start_date.month) + deal.end_date.month
    end

    if(deal.end_date.day < (deal.start_date.day-1))
      months -= 1 
      days = deal.start_date.end_of_month.day - deal.start_date.day
      days += deal.end_date.day
    end

    months += years * 12

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

    msg = []
    msg << "No. of Months : #{months}, Price : #{months}x#{place.monthly} \n" if(months > 0)
    msg << "No. of Weeks : #{weeks}, Price : #{weeks}x#{place.weekly} \n" if(weeks > 0)
    msg << "No. of Weekdays : #{weekdays}, Price : #{weekdays}x#{place.daily} \n" if(weekdays > 0)
    msg << "No. of Weekends : #{weekends}, Price : #{weekends}x#{place.weekend} \n" if(weekends > 0)
    msg << "Additional guests : #{place.add_guests}, Price : #{place.add_guests}x#{place.add_price}" if(place.add_guests and deal.guests >= place.add_guests)
    msg << "Total Amount : #{amount.round(2)} + 10% Service Charge : #{(0.1 * amount).round(2)}"
    return amount, msg
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
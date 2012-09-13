module DealHelper

	def self.calculate_price(deal, place)
    amount = 0.0
    days = deal.end_date.day - deal.start_date.day
    months = deal.end_date.month - deal.start_date.month
    
    if(deal.end_date.day < (deal.start_date.day-1))
      months -= 1 
      days = deal.start_date.end_of_month.day - deal.start_date.day
      days += deal.end_date.day
    end

    weeks = days / 7
    days = days % 7
    
    amount += weeks * place.weekly
    amount += months * place.monthly

    (deal.start_date..(deal.start_date+days)).to_a.each do |date|
      if(date.sunday? or date.saturday?)
        amount += place.weekend
      else
        amount += place.daily
      end
    end

      if(place.add_guests and deal.guests >= place.add_guests)
        amount += (deal.guests - place.add_guests) * place.add_price
      end

    amount
  end

  def self.check_deal(deal, place)
    if(place.detail.accomodation != "" and deal.guests and deal.guests > place.detail.accomodation.to_i)
      return false, :alert, "Sorry, Maximum Accomodation for this space is #{place.details.accomodation}"
    elsif(deal.start_date and deal.start_date < Date.current)
      return false, :error, "You can't register a past event"
    elsif(deal.end_date and deal.end_date <= deal.start_date)
      return false, :error, "End date should be more than with Start date"
    else
      return check_place(deal, place)
    end
  end

  def self.check_place(deal, place)
    place_deals = Deal.by_place(place)
    dates = (deal.start_date..deal.end_date).to_a
    place_deals.each do |place_deal|
      place_dates = (place_deal.start_date..place_deal.end_date).to_a
      if((dates & place_dates).empty? == false)
        return false, :alert, "Sorry, the place is already booked for these dates"
      end
    end
    return true
  end
end
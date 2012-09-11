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

    amount + (amount * 0.1)
  end
end
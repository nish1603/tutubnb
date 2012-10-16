module DealHelper
  def create_divisions(deal)
    division = []
    division << "No. of Months : #{deal.months}, Price : #{deal.months}x#{deal.place.monthly} \n" if(deal.months > 0)
    division << "No. of Weeks : #{deal.weeks}, Price : #{deal.weeks}x#{deal.place.weekly} \n" if(deal.weeks > 0)
    division << "No. of Weekdays : #{deal.weekdays}, Price : #{deal.weekdays}x#{deal.place.daily} \n" if(deal.weekdays > 0)
    division << "No. of Weekends : #{deal.weekends}, Price : #{deal.weekends}x#{deal.place.weekend} \n" if(deal.weekends > 0)
    division << "Additional guests : #{deal.place.add_guests}, Price : #{deal.place.add_guests}x#{deal.place.add_price}" if(deal.place.add_guests && deal.guests >= deal.place.add_guests)
    division << "Total Amount : #{deal.price.round(2)} + 10% Service Charge : #{(0.1 * deal.price).round(2)}"
    return division
  end

end
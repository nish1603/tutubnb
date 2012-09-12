module DisplayHelper
	def selection()
    places_by_city = Place.by_city(params[:city])
    places_by_city = Place.all if places_by_city.empty? 
    places_by_country = Place.by_country(params[:country]) 
    places_by_country = Place.all if places_by_country.empty?
    places_by_property_type = Place.by_property_type(params[:property_type])
    places_by_property_type = Place.all if places_by_property_type.empty?
    places_by_room_type = Place.by_room_type(params[:room_type]) 
    places_by_room_type = Place.all if places_by_room_type.empty? 
    places = places_by_city & places_by_country & places_by_room_type & places_by_property_type
    places = places_by_city if places.empty?

    if(params[:type] == 'Activated')
      places = places & Place.find_all_by_verified(true)
    elsif(params[:type] == 'Deactivated')
      places = places & Place.find_all_by_verified(false)
    end
    places
  end

  def select_users()
    users = User.find_by_email(params[:email])

    if(params[:type] == 'Activated')
        users = User.activated
    elsif(params[:type] == 'Deactivated')
        users = User.deactivated
    elsif(params[:type] == 'Not Verified')
        users = User.not_verified
    else
        users = User.all & users
    end
    users
  end

  def select_deals()
    if(params[:type] == 'Accept')
        deals = Deal.accept(true)
    elsif(params[:type] == 'Rejected')
        deals = Deal.accept(false)
    elsif(params[:type] == 'To Complete')
        deals = Deal.to_complete(true)
    elsif(params[:type] == 'Completed')
        deals = Deal.completed(true)
    else
        deals = Deal.all & users
    end
    deals
  end
end

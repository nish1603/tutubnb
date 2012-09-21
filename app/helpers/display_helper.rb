module DisplayHelper
	def selection()
    places = Place.admin_visible
    places = by_option(:by_location, [:city, :country], places)
    places = by_option(:by_property, [:property_type, :room_type], places)
    places = by_tags(places)
    

    if(session[:admin] != true or params[:type] == 'Activated')
      places = places & Place.visible(true)
    elsif(params[:type] == 'Deactivated')
      places = places & Place.visible(false)
    end
    
    places & Place.admin_visible
    places
  end

  def by_option(scope_name, options, places)
    options.each do |type|
      places = places & Place.send(scope_name, type, params[type]) unless(params[type].blank?)
    end
    places
  end

  def by_tags(places)
    tags = params[:place_tags_string].split(", ").reject{ |tag| tag.nil? or tag.blank? }
    tags.each do |place_tag|
      places_by_tag = Tag.find_by_tag(place_tag.strip)
      places = places_by_tag.places & places unless places_by_tag.nil?
    end
    places
  end


  def select_users()

    users = User.find_all_by_email(params[:email])

    if(params[:type] == 'Activated' || params[:type] == 'Deactivated' || params[:type] == 'Not_Verified' || params[:type] == 'All')
      users = User.send(params[:type].downcase)
    end
    users
  end

  def select_deals()
    if(params[:type] == 'Accepted')
        deals = Deal.accepted(true)
    elsif(params[:type] == 'Rejected')
        deals = Deal.accepted(false)
    elsif(params[:type] == 'To Complete')
        deals = Deal.to_complete(false)
    elsif(params[:type] == 'Completed')
        deals = Deal.completed(true)
    else
        deals = Deal.all
    end
    deals
  end
end

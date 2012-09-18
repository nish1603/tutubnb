module DisplayHelper
	def selection()
    places = Place.admin_visible
    places = places & Place.by_city(params[:city]) unless(params[:city].blank?)
    places = places & Place.by_country(params[:country]) unless(params[:country].blank?)
    places = places & Place.by_property_type(params[:property_type]) unless(params[:property_type].blank?)
    places = places & Place.by_room_type(params[:room_type]) unless(params[:room_type].blank?)
    
    tags = params[:place_tags_string].split(", ").reject{ |tag| tag.nil? or tag.blank? }
    tags.each do |place_tag|
      places_by_tag = Tag.find_by_tag(place_tag.strip)
      places = places_by_tag.places & places unless places_by_tag.nil?
    end

    if(session[:admin] != true or params[:type] == 'Activated')
      places = places & Place.visible(true)
    elsif(params[:type] == 'Deactivated')
      places = places & Place.visible(false)
    end
    
    places & Place.admin_visible
  end

  def select_users()

    users = [User.find_by_email(params[:email])]

    if(params[:type] == 'Activated')
        users = User.activated_and_verified
    elsif(params[:type] == 'Deactivated')
        users = User.deactivated
    elsif(params[:type] == 'Not Verified')
        users = User.not_verified
    elsif(params[:type] == 'All')
        users = User.all
    else
        users = User.all & users
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

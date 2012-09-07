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
  places
  end
end

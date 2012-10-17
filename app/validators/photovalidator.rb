# class PhotoValidator < ActiveModel::Validator
#   def validate(place)

#     photos_count = place.photos.length

#     place.photos.each do |photo|
#       if(photo.invalid? || photo.marked_for_destruction?)
#         photos_count -= 1
#       end
#     end

#     if(photos_count < 2)
#       place.errors[:base] << "Photos should be atleast 2"
#     end
#   end
# end

# #FIXME_AB: should be moved to lib or app/validators directory.
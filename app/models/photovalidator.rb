class PhotoValidator < ActiveModel::Validator
  def validate(record)

    photos_count = record.photos.length

    record.photos.each do |photo|
      if(photo.invalid? || photo.marked_for_destruction?)
        photos_count -= 1
      end
    end

    if(photos_count < 2)
      record.errors[:base] << "Photos should be atleast 2"
    end
  end
end
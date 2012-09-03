class Photo < ActiveRecord::Base
  attr_accessible :photo

  belongs_to :place


  has_attached_file :photo,
    :styles => {
    	:thumb => "100x100#"
    }
end

class Photo < ActiveRecord::Base
  attr_accessible :photo

  belongs_to :place


  
end

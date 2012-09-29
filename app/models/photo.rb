class Photo < ActiveRecord::Base
  attr_accessible :avatar

  has_attached_file :avatar, :styles => { :small => '100x100>', :medium => '200x200>', :large => '500x500#' }
  validates_format_of :avatar, :with => %r{\.(jpg|png|gif|jpeg)}i, :message => "Image only of .jpg, .jpeg, .gif and .png format is allowed."
  
  belongs_to :place, :inverse_of => :photos
end

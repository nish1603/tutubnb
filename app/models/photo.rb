class Photo < ActiveRecord::Base
  attr_accessible :avatar

  has_attached_file :avatar#, :styles => { :small => '100x100#' }
  validates_attachment :avatar, :presence => true

  belongs_to :place
end

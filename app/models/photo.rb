class Photo < ActiveRecord::Base
  attr_accessible :avatar

  has_attached_file :avatar#, :styles => { :small => "500x500>" }
  validates :avatar, :presence => true

  belongs_to :place
end

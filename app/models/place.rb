class Place < ActiveRecord::Base
  attr_accessible :description, :property_type, :room_type, :title
  has_one :price
  has_one :detail

  belongs_to :user
end

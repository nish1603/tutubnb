class Price < ActiveRecord::Base
  attr_accessible :add_guests, :add_price, :daily, :max_guests, :monthly, :weekend, :weekly, :place_id

  validates :daily, :max_guests, presence: true

  belongs_to :place
end

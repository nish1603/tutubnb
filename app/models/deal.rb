class Deal < ActiveRecord::Base
  attr_accessible :end_date, :price, :start_date, :guests

  belongs_to :user
  belongs_to :place
end

class Rules < ActiveRecord::Base
  attr_accessible :availables, :rules
  belongs_to :place

  validates :availables, :rules, :presence => true
end

class Tag < ActiveRecord::Base
  attr_accessible :tag

  validate :tag, :presence => true

  has_and_belongs_to_many :places
end

class Tag < ActiveRecord::Base
  attr_accessible :tag

  validates :tag, :presence => true, :uniqueness => true

  has_and_belongs_to_many :places
end

class Review < ActiveRecord::Base
  attr_accessible :description, :ratings, :subject

  validates :description, :ratings, :subject, :presence => true

  belongs_to :user
  belongs_to :place

  RATINGS = (1..10).to_a
end

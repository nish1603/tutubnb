class Review < ActiveRecord::Base
  attr_accessible :description, :ratings, :subject

  validates :description, :ratings, :subject, :presence => true
  validates :ratings, :inclusion => { :in => 1..10 }, :unless => { |review| review.ratings.blank? }

  belongs_to :user
  belongs_to :place

  RATINGS = (1..10).to_a
end

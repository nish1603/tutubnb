class Review < ActiveRecord::Base
  attr_accessible :description, :ratings, :subject

  belongs_to :user
  belongs_to :place
end

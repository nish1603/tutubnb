require 'spec_helper'

module ReviewSpecHelper
  def valid_review_attributes
    {
      :ratings => 9,
      :subject => "Its good",
      :description => "the rooms are well furnished."
    }
  end
end

describe Review do
  include ReviewSpecHelper
  
  before(:each) do
    @review = Review.new
  end

  it "ratings should not be nil" do
    @review.attributes = valid_review_attributes.except(:ratings)
    @review.should have(1).errors_on(:ratings)
  end

  it "ratings should be smaller than 10" do
    @review.attributes = valid_review_attributes.with(:ratings => 13)
    @review.should have(1).errors_on(:ratings)
  end

  it "ratings should be greater than 0" do
    @review.attributes = valid_review_attributes.with(:ratings => -2)
    @review.should have(1).errors_on(:ratings)
  end

  it "subject should not be nil" do
    @review.attributes = valid_review_attributes.except(:subject)
    @review.should have(1).errors_on(:subject)
  end

  it "description should not be nil" do
    @review.attributes = valid_review_attributes.except(:description)
    @review.should have(1).errors_on(:description)
  end
end
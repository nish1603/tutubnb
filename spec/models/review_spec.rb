require 'spec_helper'

module ReviewSpecHelper
  def valid_review_attributes
    {
      :ratings => 9,
      :subject => "Its good",
      :bedrooms => 3,
      :beds => 4
    }
  end
end

describe Detail do
  include DetailSpecHelper
  
  before(:each) do
    @detail = Detail.new
  end

  it "accomodation should not be nil" do
    @detail.attributes = valid_detail_attributes.except(:accomodation)
    @detail.should have(1).errors_on(:accomodation)
  end

  it "accomodation should be greater than zero" do
    @detail.attributes = valid_detail_attributes.with(:accomodation => -2)
    @detail.should have(1).errors_on(:accomodation)
  end

  it "accomodation should be integer" do
    @detail.attributes = valid_detail_attributes.with(:accomodation => 2.2)
    @detail.should have(1).errors_on(:accomodation)
  end

  it "bedrooms should be greater than zero" do
    @detail.attributes = valid_detail_attributes.with(:bedrooms => -2)
    @detail.should have(1).errors_on(:bedrooms)
  end

  it "bedrooms should be integer" do
    @detail.attributes = valid_detail_attributes.with(:bedrooms => 2.2)
    @detail.should have(1).errors_on(:bedrooms)
  end

  it "bathrooms should be greater than zero" do
    @detail.attributes = valid_detail_attributes.with(:bathrooms => -2)
    @detail.should have(1).errors_on(:bathrooms)
  end

  it "bathrooms should be integer" do
    @detail.attributes = valid_detail_attributes.with(:bathrooms => 2.2)
    @detail.should have(1).errors_on(:bathrooms)
  end

  it "beds should be greater than zero" do
    @detail.attributes = valid_detail_attributes.with(:beds => -2)
    @detail.should have(1).errors_on(:beds)
  end

  it "beds should be integer" do
    @detail.attributes = valid_detail_attributes.with(:beds => 2.2)
    @detail.should have(1).errors_on(:beds)
  end
end
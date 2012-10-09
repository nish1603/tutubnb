require 'spec_helper'

module DetailSpecHelper
  def valid_detail_attributes
    {
      :accomodation => 9,
      :bathrooms => 2,
      :bedrooms => 3,
      :beds => 4,
      :size => 500,
      :unit => 2

    }
  end

  def valid_place_attributes
    {
      :description => "Its an awesome place",
      :property_type => 2,
      :room_type => 1,
      :title => "Awesome",
      :add_guests => 5, 
      :add_price => 400.0,
      :daily => 300,
      :monthly => 8000,
      :weekend => 300,
      :weekly => 2000
    }
  end
end

describe Detail do
  include DetailSpecHelper
  
  before(:each) do
    @detail = Detail.new
  end

  describe "Validations" do
    context "Accomodation" do
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
    end

    context "Bedrooms" do
      it "bedrooms should be greater than zero" do
        @detail.attributes = valid_detail_attributes.with(:bedrooms => -2)
        @detail.should have(1).errors_on(:bedrooms)
      end

      it "bedrooms should be integer" do
        @detail.attributes = valid_detail_attributes.with(:bedrooms => 2.2)
        @detail.should have(1).errors_on(:bedrooms)
      end
    end

    context "Bathrooms" do
      it "bathrooms should be greater than zero" do
        @detail.attributes = valid_detail_attributes.with(:bathrooms => -2)
        @detail.should have(1).errors_on(:bathrooms)
      end

      it "bathrooms should be integer" do
        @detail.attributes = valid_detail_attributes.with(:bathrooms => 2.2)
        @detail.should have(1).errors_on(:bathrooms)
      end
    end

    context "Beds" do
      it "beds should be greater than zero" do
        @detail.attributes = valid_detail_attributes.with(:beds => -2)
        @detail.should have(1).errors_on(:beds)
      end

      it "beds should be integer" do
        @detail.attributes = valid_detail_attributes.with(:beds => 2.2)
        @detail.should have(1).errors_on(:beds)
      end
    end
  end

  describe "Relationships" do
    before(:each) do
      @place = Place.create(valid_place_attributes)
    end

    context "with Place" do
      it "should respond to place" do
        @address.should respond_to(:place)
      end

      it "should have a place" do
        @address.place = @place
        @deal.should have(0).errors_on(:place)
      end

      it "should return a user" do
        @address.place.should eq(@place)
      end
    end
  end

  describe "Functions" do
    context "unit_string" do
      @address.unit_string.should == "sq. feet"
    end
  end
end
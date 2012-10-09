require 'spec_helper'

module AddressSpecHelper
  def valid_address_attributes
    {
      :address_line1 => "c-140, rama park",
      :address_line2 => "uttam nagar",
      :city => "new delhi",
      :state => "delhi",
      :pincode => 110059,
      :country => "India"
    }
  end

  def invalid_address_attributes
    {
      :address_line1 => "l",
      :address_line2 => "l",
      :city => "l",
      :state => "delhi",
      :pincode => 1,
      :country => "afganistan"
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

describe Address do
  include AddressSpecHelper
  
  before(:each) do
    @address = Address.new
  end

  describe "Validation" do
    context "Address line 1" do
      it "should not be nil" do
        @address.attributes = valid_address_attributes.except(:address_line1)
        @address.should have(1).errors_on(:address_line1)
      end

      it "should be unique" do
        @address1 = Address.create(valid_address_attributes)
        @address.attributes = valid_address_attributes
        @address.should have(1).errors_on(:address_line1)
      end
    end


    context "City" do
      it "should not be nil" do
        @address.attributes = valid_address_attributes.except(:city)
        @address.should have(1).errors_on(:city)
      end

      it "should be a string" do
        @address.attributes = valid_address_attributes.with(:city => 1234)
        @address.should have(1).errors_on(:city)
      end
    end

    context "State" do
      it "should not be nil" do
        @address.attributes = valid_address_attributes.except(:state)
        @address.should have(1).errors_on(:state)
      end

      it "should be a string" do
        @address.attributes = valid_address_attributes.with(:state => 1234)
        @address.should have(1).errors_on(:state)
      end
    end

    context "Pincode" do
      it "should not be nil" do
        @address.attributes = valid_address_attributes.except(:pincode)
        @address.should have(1).errors_on(:pincode)
      end

      it "should be an integer" do
        @address.attributes = valid_address_attributes.with(:pincode => 112.345)
        @address.should have(1).errors_on(:pincode)
      end
    end
  
    context "Country" do 
      it "should not be nil" do
        @address.attributes = valid_address_attributes.except(:country)
        @address.should have(1).errors_on(:country)
      end

      it "should be a string" do
        @address.attributes = valid_address_attributes.with(:country => 1234)
        @address.should have(1).errors_on(:country)
      end
    end
  end

  describe "Relationships" do

    before(:each) do
      @place = Place.create(valid_place_attributes)
      @address.place = @place
    end

    context "with Place" do
      it "should respond to place" do
        @address.should respond_to(:place)
      end

      it "should have a place" do
        @address.place = @place
        @address.should have(0).errors_on(:place)
      end

      it "should return a place" do
        @address.place.should eq(@place)
      end
    end
  end

  describe "Gmap" do
    context "Function" do
      it "gmaps4rails_address" do
        address = [@address.address_line1, @address.address_line2, @address.city, @address.state, @address.pincode, @address.country].join(", ")
        @address.gmaps4rails_address.should eq(address)
      end
    end

    context "latitude and longitude" do
      before(:each) do
        @address.attributes = valid_address_attributes
        @address.save
      end

      it "should fill latitude and longitude" do
        p @address
        @address.latitude.nil?.should be_false
        @address.longitude.nil?.should be_false
      end
    end

    context "Validations" do
      before(:each) do
        @address = Address.create(invalid_address_attributes)
      end

      it "should be invalid" do
        @address.should have(1).errors
      end
    end
  end
end
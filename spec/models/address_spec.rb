require 'spec_helper'

module AddressSpecHelper
  def valid_address_attributes
    {
      :address_line1 => "c-140, rama park",
      :address_line2 => "uttam nagar",
      :city => "new delhi",
      :state => "delhi",
      :pincode => "110059",
      :country => "India"
    }
  end
end

describe Address do
  include AddressSpecHelper
  
  before(:each) do
    @address = Address.new
  end

  it "address_line1 should not be nil" do
    @address.attributes = valid_address_attributes.except(:address_line1)
    @address.should have(1).errors_on(:address_line1)
  end

  it "city should not be nil" do
    @address.attributes = valid_address_attributes.except(:city)
    @address.should have(1).errors_on(:city)
  end

  it "city should be a string" do
    @address.attributes = valid_address_attributes.with(:city => 1234)
    @address.should have(1).errors_on(:city)
  end

  it "state should not be nil" do
    @address.attributes = valid_address_attributes.except(:state)
    @address.should have(1).errors_on(:state)
  end

  it "state should be a string" do
    @address.attributes = valid_address_attributes.with(:state => 1234)
    @address.should have(1).errors_on(:state)
  end


  it "pincode should not be nil" do
    @address.attributes = valid_address_attributes.except(:pincode)
    @address.should have(1).errors_on(:pincode)
  end

  it "pincode should be an integer" do
    @address.attributes = valid_address_attributes.with(:pincode => 112.345)
    @address.should have(1).errors_on(:pincode)
  end
  
  it "country should not be nil" do
    @address.attributes = valid_address_attributes.except(:country)
    @address.should have(1).errors_on(:country)
  end

  it "country should be a string" do
    @address.attributes = valid_address_attributes.with(:country => 1234)
    @address.should have(1).errors_on(:country)
  end

  it "address should be unique" do
    @address1 = Address.create(valid_address_attributes)
    @address.attributes = valid_address_attributes
    @address.should have(1).errors_on(:address_line1)
  end
end
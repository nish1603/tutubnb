require 'spec_helper'

module PlaceSpecHelper
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

  def valid_detail_attributes
    {
      :accomodation => 9,
      :bathrooms => 2,
      :bedrooms => 3,
      :beds => 4
    }
  end

  def valid_review_attributes
    {
      :ratings => 9,
      :subject => "Its good",
      :description => "the rooms are well furnished."
    }
  end

  def valid_deal_attributes
    {
      :start_date => "22/09/2013",
      :end_date => "24/09/2013",
      :guests => 4,
      :price => 8000
    }
  end
end

describe Place do
  include PlaceSpecHelper
	before(:each) do
    @place = Place.new
  end

  describe "validations" do
    it "description should not be nil" do
      @place.attributes = valid_place_attributes.except(:description)
      @place.should have(1).errors_on(:description)
    end

    it "title should not be nil" do
      @place.attributes = valid_place_attributes.except(:title)
      @place.should have(1).errors_on(:title)
    end

    it "room_type should not be nil" do
      @place.attributes = valid_place_attributes.except(:room_type)
      @place.should have(1).errors_on(:room_type)
    end

    it "property_type should not be nil" do
      @place.attributes = valid_place_attributes.except(:property_type)
      @place.should have(1).errors_on(:property_type)
    end

    it "daily should not be nil" do
      @place.attributes = valid_place_attributes.except(:daily)
      @place.should have(1).errors_on(:daily)
    end

    it "daily should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:daily => -2)
      @place.should have(1).errors_on(:daily)
    end

    it "weekend should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:weekend => -2)
      @place.should have(1).errors_on(:weekend)
    end

    it "weekly should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:weekly => -2)
      @place.should have(1).errors_on(:weekly)
    end

    it "monthly should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:monthly => -2)
      @place.should have(1).errors_on(:monthly)
    end

    it "additional guests should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:add_guests => -2)
      @place.should have(1).errors_on(:add_guests)
    end

    it "additional price should be greater than or equal to zero" do
      @place.attributes = valid_place_attributes.with(:add_price => -2)
      @place.should have(1).errors_on(:add_price)
    end
  end

  describe "Relationship with Address" do

    before(:each) do
      @address = Address.create(valid_address_attributes)
      @place.address = @address
    end

    it "should have one address" do
      @place.should respond_to(:address)
    end

    it "should return an address" do
      @place.address.should eq(@address)
    end

    it "should destroy address when destroyed" do
      @place.destroy
      @place.address.destroyed?.should be_true
    end
  end

  describe "Relationship with Detail" do

    before(:each) do
      @detail = Detail.create(valid_detail_attributes)
      @place.detail = @detail
    end

    it "should have one detail" do
      @place.should respond_to(:detail)
    end

    it "should return an detail" do
      @place.detail.should eq(@detail)
    end

    it "should destroy detail when destroyed" do
      @place.destroy
      @place.detail.destroyed?.should be_true
    end
  end

  describe "Relationship with Review" do

    before(:each) do
      @review1 = Review.create(valid_review_attributes)
      @review2 = Review.create(valid_review_attributes)
      @place.reviews = [@review1, @review2]
    end

    it "should have many review" do
      @place.should respond_to(:reviews)
    end

    it "should return reviews" do
      @place.reviews.should eq([@review1, @review2])
    end

    it "should destroy reviews when destoyed" do
      @place.destroy
      @place.reviews.should have(0).items
    end
  end

  describe "Relationship with Deal" do

    before(:each) do
      @deal1 = Deal.create(valid_deal_attributes)
      @deal2 = Deal.create(valid_deal_attributes)
      @place.deals = [@deal1, @deal2]
    end

    it "should have many deal" do
      @place.should respond_to(:deals)
    end

    it "should return deals" do
      @place.deals.should eq([@deal1, @deal2])
    end

    it "should destroy deals when destoyed" do
      @place.destroy
      @place.deals.should have(0).items
    end
  end
end
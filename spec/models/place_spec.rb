require 'spec_helper'

module PlaceSpecHelper
  def valid_place_attributes
    {
      :description => "Its an awesome place",
      :property_type => 2,
      :room_type => 1,
      :title => "Awesome",
      :additional_guests => 5, 
      :additional_price => 400.0,
      :daily_price => 300,
      :monthly_price => 8000,
      :weekend_price => 300,
      :weekly_price => 2000
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

  def valid_rules_attributes
    {
      :rules => "No Smoking",
      :availables => "fridge, t.v."
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
      :guests => 4
    }
  end
end

describe Place do
  include PlaceSpecHelper
	before(:each) do
    @place = Place.new
  end

  describe "Validations" do
    context "description" do
      it "should not be nil" do
        @place.attributes = valid_place_attributes.except(:description)
        @place.should have(1).errors_on(:description)
        @place.errors_on(:description).should eq(["can't be blank"])
      end
    end

    context "title" do
      it "should not be nil" do
        @place.attributes = valid_place_attributes.except(:title)
        @place.should have(1).errors_on(:title)
        @place.errors_on(:title).should eq(["can't be blank"])
      end
    end

    context "room_type" do
      it "should not be nil" do
        @place.attributes = valid_place_attributes.except(:room_type)
        @place.should have(1).errors_on(:room_type)
        @place.errors_on(:room_type).should eq(["can't be blank"]) 
      end
    end

    context "property_type" do
      it "property_type should not be nil" do
        @place.attributes = valid_place_attributes.except(:property_type)
        @place.should have(1).errors_on(:property_type)
        @place.errors_on(:property_type).should eq(["can't be blank"])
      end
    end

    context "daily_price" do
      it "should not be nil" do
        @place.attributes = valid_place_attributes.except(:daily_price)
        @place.should have(1).errors_on(:daily_price)
        @place.errors_on(:daily_price).should eq(["can't be blank"])
      end

      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:daily_price => -2)
        @place.should have(1).errors_on(:daily_price)
        @place.errors_on(:daily_price).should eq(["must be greater than or equal to 0"])
      end
    end

    context "weekend_price" do
      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:weekend_price => -2)
        @place.should have(1).errors_on(:weekend_price)
        @place.errors_on(:weekend_price).should eq(["must be greater than or equal to 0"])
      end
    end

    context "weekly_price" do
      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:weekly_price => -2)
        @place.should have(1).errors_on(:weekly_price)
        @place.errors_on(:weekly_price).should eq(["must be greater than or equal to 0"])
      end
    end

    context "monthly_price" do
      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:monthly_price => -2)
        @place.should have(1).errors_on(:monthly_price)
        @place.errors_on(:monthly_price).should eq(["must be greater than or equal to 0"])
      end
    end

    context "additional guests" do
      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:additional_guests => -2)
        @place.should have(1).errors_on(:additional_guests)
        @place.errors_on(:additional_guests).should eq(["must be greater than or equal to 0"])
      end

      it "should be only integer" do
        @place.attributes = valid_place_attributes.with(:additional_guests => 2.8)
        @place.should have(1).errors_on(:additional_guests)
        @place.errors_on(:additional_guests).should eq(["must be an integer"])
      end
    end

    context "addtional price" do
      it "should be greater than or equal to zero" do
        @place.attributes = valid_place_attributes.with(:additional_price => -2)
        @place.should have(1).errors_on(:additional_price)
        @place.errors_on(:additional_price).should eq(["must be greater than or equal to 0"])
      end
    end
  end

  describe "Association with Address" do

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

  describe "Association with Detail" do

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

  describe "Association with Reviews" do

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

  describe "Association with Deals" do
    before(:each) do
      @place.attributes = valid_place_attributes
      @place.save(:validate => false)
      @detail = Detail.create(valid_detail_attributes)
      @place.detail = @detail
      @deal1 = @place.deals.build(valid_deal_attributes)
      @deal2 = @place.deals.build(valid_deal_attributes)
    end

    it "should have many deal" do
      @place.should respond_to(:deals)
    end

    it "should return deals" do
      @place.deals.should eq([@deal1, @deal2])      
    end

    it "should destroy deals when destoyed" do
      @place.destroy
      @deal1.place_id.should be_nil
      @deal1.place_id.should be_nil
    end
  end

  describe "Association with Rules" do

    before(:each) do
      @rules = Rules.create(valid_rules_attributes)
      @place.rules = @rules
    end

    it "should have rules" do
      @place.should respond_to(:rules)
    end

    it "should return rules" do
      @place.rules.should eq(@rules)
    end

    it "should destroy rules when destroyed" do
      @place.destroy
      @place.rules.destroyed?.should be_true
    end
  end

  describe "Association with Photos" do

    before(:each) do
      @photo1 = Photo.new()
      @photo2 = Photo.new()
      @place.photos = [@photo1, @photo2]
    end

    it "should have many photos" do
      @place.should respond_to(:photos)
    end

    it "must have more than 2 photos" do
      @place.photos = [@photo1]
      @place.save
      @place.should have(1).errors_on(:base)
      @place.errors_on(:base).should eq(["Photos should be atleast 2"])
    end

    it "should return photos" do
      @place.photos.should eq([@photo1, @photo2])
    end

    it "should destroy photos when destoyed" do
      @place.destroy
      @place.photos.should have(0).items
    end
  end

  describe "Association with Tags" do

    before(:each) do
      @tag1 = Tag.new()
      @tag2 = Tag.new()
      @place.tags = [@tag1, @tag2]
    end

    it "should have many review" do
      @place.should respond_to(:tags)
    end

    it "should return photos" do
      @place.tags.should eq([@tag1, @tag2])
    end

    it "should destroy photos when destoyed" do
      @place.destroy
      @place.tags.should have(0).items
    end
  end

  describe "tags_string" do
    before(:each) do
      @tag1 = Tag.new(:tag => "fridge")
      @tag2 = Tag.new(:tag => "t.v.")
      @place.tags = [@tag1, @tag2]
    end

    it "should return a comma seprated sting of tag names" do
      @place.tags_string.should eq("fridge, t.v.")
    end
  end

  describe "tags_string=" do
    before(:each) do
      @place.save(:validate => false)
      @tag1 = Tag.create(:tag => "fridge")
      @tag2 = Tag.create(:tag => "t.v.")
      @place.tags_string = "fridge, t.v."
    end

    it "should associate with the tags" do
      @place.tags.should eq([@tag1, @tag2])
    end
  end

  describe "hide!" do
    it "should hide the place" do
      @place.hide!
      @place.hidden.should be_true
    end
  end

  describe "show!" do
    it "should hide the place" do
      @place.show!
      @place.hidden.should be_false
    end
  end

  describe "activate!" do
    it "should activate the place" do
      @place.activate!
      @place.verified.should be_true
    end
  end

  describe "deactivate!" do
    it "should deactivate the place" do
      @place.deactivate!
      @place.verified.should be_false
    end
  end

  describe "room_type_string" do
    before(:each) do
      @place.attributes = valid_place_attributes
    end

    it "should return the corresponding string of room type" do
      @place.room_type_string.should eq("Private room")
    end
  end

  describe "property_type_string" do
    before(:each) do
      @place.attributes = valid_place_attributes
    end

    it "should return the corresponding string of property type" do
      @place.property_type_string.should eq("House")
    end
  end

  describe "find_conflicting_deals" do
    before(:each) do
      @place.save(:validate => false)
      @place.create_detail(valid_detail_attributes)
      @deal1 = @place.deals.build(:start_date => "12/11/2012", :end_date => "22/11/2012", :guests => 3)
      @deal1.price = 8000
      @deal1.save
      @deal2 = @place.deals.build(:start_date => "15/12/2012", :end_date => "25/12/2012", :guests => 3)
      @deal2.price = 8000
      @deal2.save
    end

    it "should return conflicting deals" do
      @place.find_conflicting_deals(Date.new(2012,11,12), Date.new(2012,12,20)).should eq([@deal1, @deal2])
    end
  end
end
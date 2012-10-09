require 'spec_helper'

module TagSpecHelper
  def valid_tag_attributes
    {
      :tag => "fridge"
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

describe Tag do
  include TagSpecHelper
  
  before(:each) do
    @tag = Tag.new
  end

  it "can be instantiated" do
    @tag.should be_an_instance_of(Tag)
  end

  it "can be saved" do
    @tag.attributes = valid_tag_attributes
    @tag.save
    @tag.should have(0).errors_on(:tag)
  end

  describe "Validations" do
    context "tag" do
      it "tag should not be nil" do
        @tag.attributes = valid_tag_attributes.except(:tag)
        @tag.should have(1).errors_on(:tag)
        @tag.errors_on(:tag).should eq(["can't be blank"])
      end

      it "tag should be unique" do
        @tag2 = Tag.create(valid_tag_attributes)
        @tag.attributes = valid_tag_attributes
        @tag.should have(1).errors_on(:tag)
        @tag.errors_on(:tag).should eq(["has already been taken"])
      end
    end
  end

  describe "Relationships" do
    before(:each) do
      @place = Place.new(valid_place_attributes)
    end

    context "with Place" do
      it "should respond to place" do
        @tag.should respond_to(:place)
      end

      it "should have a place" do
        @tag.place = @place
        @tag.should have(0).errors_on(:place)
      end

      it "should return a user" do
        @tag.place.should eq(@place)
      end
  end
end
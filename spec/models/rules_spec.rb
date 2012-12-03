require 'spec_helper'

module RulesSpecHelper
  def valid_rules_attributes
    {
      :rules => "No smoking",
      :availables => "fridge, t.v."
    }
  end

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
end

describe Rules do
  include RulesSpecHelper
  
  before(:each) do
    @rules = Rules.new
  end

  describe "Validation" do
    context "rules" do
      it "should not be nil" do
        @rules.attributes = valid_rules_attributes.except(:rules)
        @rules.should have(1).errors_on(:rules)
      end
    end


    context "availables" do
      it "should not be nil" do
        @rules.attributes = valid_rules_attributes.except(:availables)
        @rules.should have(1).errors_on(:availables)
      end
    end

  end

  describe "Relationships" do
    before(:each) do
      @place = Place.new(valid_place_attributes)
      @rules.place = @place
    end

    context "with Place" do
      it "should respond to place" do
        @rules.should respond_to(:place)
      end

      it "should have a place" do
        @rules.place = @place
        @rules.should have(0).errors_on(:place)
      end

      it "should return a place" do
        @rules.place.should eq(@place)
      end
    end
  end
end
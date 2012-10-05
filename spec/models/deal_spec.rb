require 'spec_helper'

module DealSpecHelper
    def valid_deal_attributes
    {
      :start_date => "22/09/2013",
      :end_date => "24/09/2013",
      :guests => 4
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

    def valid_detail_attributes
    {
      :accomodation => 9,
      :bathrooms => 2,
      :bedrooms => 3,
      :beds => 4
    }
  end

  def valid_user_attributes
    { :first_name => "nishant",
      :last_name => "tuteja",
      :gender => "1",
      :email => "nishant.tuteja@vinsol.com",
      :password => "password",
      :password_confirmation => "password"
    }
  end
end

describe Deal do
  include DealSpecHelper
  
  before(:each) do
    @user = User.create(valid_user_attributes)
    @place = Place.create(valid_place_attributes)
    @detail = Detail.create(valid_detail_attributes)
    @place.detail = @detail
    @deal = Deal.new
    @deal.user = @user
    @deal.place = @place
  end

  describe "Validations" do
    context "start_date" do
      it "should not be nil" do
        @deal.attributes = valid_deal_attributes.except(:start_date)
        @deal.should have(1).errors_on(:start_date)
        @deal.errors_on(:start_date).should eq(["can't be blank"])
      end

      it "should be greater than or equal to current date" do
        @deal.attributes = valid_deal_attributes.with(:start_date => '01/01/2012')
        @deal.should have(1).errors_on(:start_date)
        @deal.errors_on(:start_date).should eq(["should be more than or equal to current date"])
      end
    end

    context "end_date" do
      it "should not be nil" do
        @deal.attributes = valid_deal_attributes.except(:end_date)
        @deal.should have(1).errors_on(:end_date)
        @deal.errors_on(:end_date).should eq(["can't be blank"])
      end

      it "should be greater than or equal to current date" do
        @deal.attributes = valid_deal_attributes.with(:end_date => '01/01/2012')
        @deal.should have(1).errors_on(:start_date)
        @deal.errors_on(:start_date).should eq(["should be more than or equal to current date"])
      end
    end
  end
end
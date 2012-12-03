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
      :additional_guests => 5, 
      :additional_price => 400.0,
      :daily_price => 300,
      :monthly_price => 8000,
      :weekend_price => 300,
      :weekly_price => 2000
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
    @owner = User.create(valid_user_attributes)
    @place = Place.create(valid_place_attributes)
    @detail = Detail.create(valid_detail_attributes)
    @place.detail = @detail
    @place.user = @owner
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

      it "should be greater than or equal to start date" do
        @deal.attributes = valid_deal_attributes.with(:end_date => '01/01/2012')
        @deal.should have(1).errors_on(:end_date)
        @deal.errors_on(:end_date).should eq(["should be more than or equal to start date"])
      end
    end

    context "price" do
      it "should be greater than or equal to 0" do
          @deal.attributes = valid_deal_attributes
          @deal.price = -1.0
          @deal.should have(1).errors_on(:price)
          @deal.errors_on(:price).should eq(["must be greater than or equal to 0"])
      end
    end

    context "guests" do
      it "should be greater than or equal to 0" do
          @deal.attributes = valid_deal_attributes.with(:guests => -2)
          @deal.should have(1).errors_on(:guests)
          @deal.errors_on(:guests).should eq(["must be greater than or equal to 1"])
      end

      it "should be an integer" do
          @deal.attributes = valid_deal_attributes.with(:guests => 2.2)
          @deal.should have(1).errors_on(:guests)
          @deal.errors_on(:guests).should eq(["must be an integer"])
      end
    end

    context "place" do
      it "should not be nil" do
          @deal.attributes = valid_deal_attributes
          @deal.should have(1).errors_on(:place_id)
          @deal.errors_on(:place_id).should eq(["can't be blank"])
      end
    end

    context "user" do
      it "should not be nil" do
          @deal.attributes = valid_deal_attributes
          @deal.user_id = nil
          @deal.should have(1).errors_on(:user_id)
          @deal.errors_on(:user_id).should eq(["can't be blank"])
      end
    end
  end


  describe "Associations" do
    context "with User" do
      it "should respond to user" do
        @deal.should respond_to(:user)
      end

      it "should have a user" do
        @deal.user = @user
        @deal.should have(0).errors_on(:user)
      end

      it "should return a user" do
        @deal.user.should eq(@user)
      end
    end

    context "with Place" do
      it "should respond to place" do
        @deal.should respond_to(:place)
      end

      it "should have a place" do
        @deal.place = @place
        @deal.should have(0).errors_on(:place)
      end

      it "should return a user" do
        @deal.place.should eq(@place)
      end
    end
  end

  describe "owner" do 
    it "should return the owner of deal" do
      @deal.owner.should eq(@owner)
    end
  end

  describe "accept!" do
    before(:each) do
      @deal.attributes = valid_deal_attributes
      @deal.price = 8000
      @admin = User.create(valid_user_attributes.with(:email => "nishant1603@gmail.com"))
      @admin.admin = true
      @admin.wallet = 20000
      @admin.save
      @user.wallet = 20000
      @deal1 = @deal.clone
      @deal1.state = 0
      @deal1.save
    end

    it "should accept the deal" do
      @deal.accept!
      @deal.state.should eq(1)
    end

    it "should transfer money to admin" do
      @deal.accept!
      @user.wallet.should eq(11200.0)
      @admin.reload
      @admin.wallet.should eq(28800.0)
    end

    it "should reject the other contradicting deals" do
      @deal.accept!
      @deal1.state.should eq(2)
    end
  end

  describe "reject!" do
    it "should accept the deal" do
      @deal.reject!
      @deal.state.should eq(2)
    end
  end

  describe "mark_completed!" do
    before(:each) do
      @deal.attributes = valid_deal_attributes
      @deal.price = 8000
      @admin = User.create(valid_user_attributes.with(:email => "nishant1603@gmail.com"))
      @admin.admin = true
      @admin.wallet = 20000
      @admin.save
    end

    it "should accept the deal" do
      @deal.mark_completed!
      @deal.state.should eq(4)
    end

    it "should transfer money from admin" do
      @deal.mark_completed!
      @admin.reload
      @owner.wallet.should eq(7200.0)
      @admin.wallet.should eq(12800.0)
    end
  end

  describe "add_brokerage_to_price" do
    it "should return price after adding brokerage" do
      Deal.add_brockerage_to_price(1000).should eq(1100)
    end
  end

  describe "subtract_brokerage_from_price" do
    it "should return price after subtracting brokerage" do
      Deal.subtract_brockerage_from_price(1000).should eq(900)
    end
  end

  # describe "calculate_price_for_addtional_guest" do
  #   before(:each) do
  #   end

  #   context "No additional_guests for place" do
  #     it "should have no additonal"
  #   end
  # end
end
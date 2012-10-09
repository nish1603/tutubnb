require 'spec_helper'

module ReviewSpecHelper

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

  def valid_user_attributes
    { :first_name => "nishant",
      :last_name => "tuteja",
      :gender => "1",
      :email => "nishant.tuteja@vinsol.com",
      :password => "password",
      :password_confirmation => "password"
    }
  end

  def valid_review_attributes
    {
      :ratings => 9,
      :subject => "Its good",
      :description => "the rooms are well furnished."
    }
  end
end

describe Review do
  include ReviewSpecHelper
  
  before(:each) do
    @user = User.create(valid_user_attributes)
    @place = Place.create(valid_place_attributes)
    @review = Review.new
    @review.user = @user
    @review.place = @place
  end

  describe "Validations" do
    context "ratings" do
      it "should not be nil" do
        @review.attributes = valid_review_attributes.except(:ratings)
        @review.should have(1).errors_on(:ratings)
      end

      it "should be smaller than 10" do
        @review.attributes = valid_review_attributes.with(:ratings => 13)
        @review.should have(1).errors_on(:ratings)
      end

      it "should be greater than 0" do
        @review.attributes = valid_review_attributes.with(:ratings => -2)
        @review.should have(1).errors_on(:ratings)
      end
    end

    context "subject" do
      it "should not be nil" do
        @review.attributes = valid_review_attributes.except(:subject)
        @review.should have(1).errors_on(:subject)
      end
    end

    context "description" do
      it "should not be nil" do
        @review.attributes = valid_review_attributes.except(:description)
        @review.should have(1).errors_on(:description)
      end
    end
  end

  describe "Relationships" do
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
end
require 'spec_helper'

module UserSpecHelper
  def valid_user_attributes
    { :first_name => "nishant",
      :last_name => "tuteja",
      :gender => "1",
      :email => "nishant.tuteja@vinsol.com",
      :password => "password",
      :password_confirmation => "password",
      # :avatar => "390550_2061284230599_1911003160_n.jpg",
      # :avatar_content_type => "image/jpeg",
      # :avatar_file_size => 17185,
      # :avatar_updated_at => Time.now
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

  def valid_deal_attributes
    {
      :start_date => "22/09/2013",
      :end_date => "24/09/2013",
      :guests => 4
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


end

describe User do
  include UserSpecHelper
  before(:each) do
    @user = User.new
  end
  describe "Validations" do
    context "first name" do
      it "should not be nil" do
        @user.attributes = valid_user_attributes.except(:first_name)
        @user.should have(1).error_on(:first_name)
      end
    end

    context "last name" do
      it "should not be nil" do
        @user.attributes = valid_user_attributes.except(:last_name)
        @user.should have(1).error_on(:last_name)
      end
    end

    context "gender" do
      it "should not be nil" do
        @user.attributes = valid_user_attributes.except(:gender)
        @user.should have(1).error_on(:gender)
      end
    end

    context "email" do
      it "should not be nil" do
        @user.attributes = valid_user_attributes.except(:email)
        @user.should have(1).error_on(:email)
      end

      it "should be in proper format" do
        @user.attributes = valid_user_attributes.except(:email)
        @user.email = "nishant"
        @user.should have(1).error_on(:email)
      end

      it "should be unique" do
        @user2 = User.create(valid_user_attributes)
        @user.attributes = valid_user_attributes
        @user.should have(1).error_on(:email)
      end
    end

    context "password" do
      it "should not be nil" do
        @user.attributes = valid_user_attributes.except(:password)
        @user.should have(1).error_on(:password)
      end

      it "should be at least 6 characters" do
        @user.attributes = valid_user_attributes.except(:password)
        @user.password = "1234"
        @user.should have(2).error_on(:password)
      end
    end

    context "password confirmation" do
      it "password_confirmation should not be nil" do
        @user.attributes = valid_user_attributes.except(:password_confirmation)
        @user.should have(1).error_on(:password_confirmation)
      end
    end
  end

  describe "Association with Places" do

    before(:each) do
      @place1 = Place.create(valid_place_attributes)
      @place2 = Place.create(valid_place_attributes)
      @user.places = [@place1, @place2]
    end

    it "should have many places" do
      @user.should respond_to(:places)
    end

    it "should return places" do
      @user.places.should eq([@place1, @place2])
    end

    it "should destroy reviews when destoyed" do
      @user.destroy
      @user.places.should have(0).items
    end
  end

  describe "Association with Trips" do
    before(:each) do
      @place = Place.new(valid_place_attributes)
      @place.build_detail(valid_detail_attributes)
      @deal1 = @place.deals.build(valid_deal_attributes)
      @deal2 = @place.deals.build(valid_deal_attributes)
      @user.trips = [@deal1, @deal2]
    end

    it "should have many trips" do
      @user.should respond_to(:trips)
    end

    it "should return trips" do
      @user.trips.should eq([@deal1, @deal2])
    end

    it "should destroy reviews when destoyed" do
      @user.destroy
      @deal1.user_id.should be_nil
      @deal2.user_id.should be_nil 
    end
  end

  describe "Association with Reviews" do
    before(:each) do
      @review1 = Review.create(valid_review_attributes)
      @review2 = Review.create(valid_review_attributes)
      @user.reviews = [@review1, @review2]
    end

    it "should have many reviews" do
      @user.should respond_to(:reviews)
    end

    it "should return trips" do
      @user.reviews.should eq([@review1, @review2])
    end

    it "should destroy reviews when destoyed" do
      @user.destroy
      @user.reviews.should have(0).items
    end
  end

  describe "transfer_from_admin!" do
    before(:each) do
      @admin = User.new(valid_user_attributes.with(:email => "nishant1603@gmail.com"))
      @admin.admin = true
      @admin.wallet = 20000
      @admin.save
    end

    it "transfer money from admin to user" do
      @user.transfer_from_admin!(1000)
      @user.wallet.should eq(900)
      @admin.reload
      @admin.wallet.to_i.should be(19100)
    end
  end

  describe "transfer_to_admin!" do
    before(:each) do
      @admin = User.new(valid_user_attributes.with(:email => "nishant1603@gmail.com"))
      @admin.admin = true
      @admin.wallet = 20000
      @admin.save
      @user.wallet = 20000
    end

    it "transfer money from admin to user" do
      @user.transfer_to_admin!(1000)
      @user.wallet.should eq(18900)
      @admin.reload
      @admin.wallet.to_i.should eq(21100)
    end
  end

  describe "deactivate!" do
    before(:each) do
      @user.activated = true
      @place = @user.places.build(valid_place_attributes)
      @place.verified = true
    end

    it "should deactivate user" do
      @user.deactivate!()
      @user.activated.should be_false
      @place.verified.should be_false
    end
  end

  describe "activate!" do
    before(:each) do
      @user.activated = false
      @place = @user.places.build(valid_place_attributes)
      @place.verified = false
    end

    it "should deactivate user" do
      @user.activate!()
      @user.activated.should be_true
      @place.verified.should be_true
    end
  end

  describe "update_wallet" do
    before(:each) do
      @user.wallet = 20000
    end

    context "when called for addition" do
      it "should add to user's account" do
        @user.update_wallet("Add", 1000)
        @user.wallet.should eq(21000)
      end
    end

    context "when called for subtraction" do
      it "should subtract from user's account" do
        @user.update_wallet("Subtract", 1000)
        @user.wallet.should eq(19000)
      end
    end
  end  
end
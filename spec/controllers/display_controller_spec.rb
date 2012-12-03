require 'spec_helper'

describe DisplayController do
  before do
	  @place1 = double(Place)
    @place2 = double(Place)
    @user = double(User)
  end

	describe "Action Show" do
	  def do_show
	  	get :show
	  end

	  context "when show calls" do
      before(:each) do
        session[:user_id] = 1
        controller.stub(:current_user).and_return(@user)
      end

      context "with current user as admin" do
	      before(:each) do
          @places = [@place1]
          @user.stub(:admin).and_return(true)
        end

	      it "should render the places" do
          Place.should_receive(:hidden).with(false).and_return(@places)
          do_show
          response.should be_success
	      end
      end

      context "with current user as normal user" do
        before(:each) do
          @places = [@place2]
          @user.stub(:admin).and_return(false)
        end

        it "should render the places" do
          Place.should_receive(:verified).with(true).and_return(@places)
          do_show
          response.should be_success
        end
      end
   	end
  end
end
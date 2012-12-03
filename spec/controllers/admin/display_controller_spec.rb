require 'spec_helper'

describe Admin::DisplayController do
  before do
    @user1 = double(User)
    @user2 = double(User)
    @users = [@user1, @user2]
  end

	describe "Action User" do
	  def do_user
	  	get :user
	  end

	  context "when user calls" do
      before(:each) do
        session[:user_id] = 1
        controller.stub(:current_user).and_return(@user1)
      end

      context "with no current user" do
        before(:each) do
          session[:user_id] = nil
          User.should_receive(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_user
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "with current user not as admin" do
	      before(:each) do
          User.should_receive(:find_by_id).with(1).and_return(@user1)
          @user1.should_receive(:admin).and_return(false)
        end

	      it "should render the places" do
          do_user
          response.should redirect_to root_url
	      end
      end

      context "with current user as admin" do
        before(:each) do
          User.should_receive(:find_by_id).with(1).and_return(@user1)
          @user1.stub(:admin).and_return(false)
          User.should_receive(:all).and_return(@users)
        end

        it "should render the places" do
          do_user
          response.should be_success
        end
      end
   	end
  end

  describe "Action Deals" do
    def do_deals
      get :deals
    end

    context "when deals calls" do
      before(:each) do
        @deal1 = double(User)
        @deal2 = double(User)
        @deals = [@deal1, @deal2]
        session[:user_id] = 1
        controller.stub(:current_user).and_return(@user1)
      end

      context "with no current user" do
        before(:each) do
          session[:user_id] = nil
          User.should_receive(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_deals
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "with current user not as admin" do
        before(:each) do
          User.should_receive(:find_by_id).with(1).and_return(@user1)
          @user1.should_receive(:admin).and_return(false)
        end

        it "should render the deals" do
          do_deals
          response.should redirect_to root_url
        end
      end

      context "with current user as admin" do
        before(:each) do
          User.should_receive(:find_by_id).with(1).and_return(@user1)
          @user1.stub(:admin).and_return(false)
          Deal.should_receive(:all).and_return(@deals)
        end

        it "should render the places" do
          do_deals
          response.should be_success
        end
      end
    end
  end
end
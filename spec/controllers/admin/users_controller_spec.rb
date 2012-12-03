require 'spec_helper'

describe Admin::UsersController do
  before(:each) do
    @user = double(User)
    @user1 = double(User, :id => 2)
  end

	describe "Action Activate" do
	  def do_activate
	  	post :activate, :flag => "active", :id => "2"
	  end

	  context "when activate calls" do
      before(:each) do
        session[:user_id] = 1
        controller.stub(:current_user).and_return(@user)
      end

      context "with no current user" do
        before(:each) do
          session[:user_id] = nil
          User.should_receive(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_activate
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "with current user not as admin" do
	      before(:each) do
          User.should_receive(:find_by_id).with(1).and_return(@user)
          @user.should_receive(:admin).and_return(false)
        end

	      it "should redirect to root_url" do
          do_activate
          response.should redirect_to root_url
	      end
      end

      context "with current user as admin" do
        before(:each) do
          @user1.should_receive(:activated).and_return(true)
          User.should_receive(:find_by_id).with(1).and_return(@user)
          @user.should_receive(:admin).and_return(true)
        end

        context "when operation done successfully" do
          before(:each) do
            controller.stub(:perform_activate).and_return(true)
          end

          it "should redirect to admin_places_path" do
            do_activate
            flash.notice.should eq("#{@place.title} is now active")
            response.should redirect_to root_url
          end
        end

        context "when operation done successfully" do
          before(:each) do
            controller.stub(:perform_activate).and_return(false)
          end

          it "should redirect to admin_places_path" do
            do_activate
            flash[:error].should eq("#{@place.title} has not been verified")
            response.should redirect_to root_url
          end
        end
      end
   	end
  end
end
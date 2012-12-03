require 'spec_helper'

describe PlacesController do
  before(:each) do
	  @user = double(User)
    @detail = double(Detail)
    @address = double(Address)
    @place = double(Place)
    @photo1 = double(Photo)
    @photo2 = double(Photo)
    @photos = [@photo1]
  end

	describe "Action New" do
	  def do_new
	  	get :new
	  end

	  context "when new calls" do
      context "when user is not log in" do
  	    before(:each) do
  	    	session[:user_id] = nil
  	      User.stub(:find_by_id).with(nil).and_return(nil)
        end

  	    it "should redirect to login page" do
          do_new
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
  	    end
      end

      context "when a user is logged in" do
        before do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)

          Place.should_receive(:new).and_return(@place)
          @place.should_receive(:build_address).and_return(@address)
          @place.should_receive(:build_detail).and_return(@address)
          @place.should_receive(:build_rules).and_return(@address)
          2.times { @place.should_receive(:photos).and_return(@photos)
          @photos.should_receive(:build).and_return(@photo2) }
        end

        it "should redirect to login" do
          do_new
          response.should be_success
        end
      end
    end
  end

  describe "Action Create" do
    def do_create
      post :create
    end

    context "when create calls" do
      context "when user is not log in" do
        before(:each) do
          session[:user_id] = nil
          User.stub(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_create
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "when a user is logged in" do
        before do
          session[:user_id] = 1
          @places = []
          User.stub(:find_by_id).with(1).and_return(@user)
          controller.stub(:current_user).and_return(@user)
          @user.stub(:places).and_return(@places)
          @places.stub(:build).and_return(@place)

          @place.stub(:save).with({:validate => true}).and_return(true)
        end

        it "should redirect to login" do
          do_create
          response.should redirect_to root_url
        end
      end
    end
  end


  describe "Action Edit" do
    def do_edit
      get :edit, :id => 1
    end

    context "when edit calls" do
      context "when user is not log in" do
        before(:each) do
          session[:user_id] = nil
          User.stub(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_edit
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "and the place doesn't exist" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(nil)
        end

        it "should redirect to login page" do
          do_edit
          response.should redirect_to root_url
        end
      end

      context "and the current user is not the owner of the place" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(2)
        end

        it "should redirect to login page" do
          do_edit
          response.should redirect_to root_url
        end
      end

      context "should edit the place" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(1)
        end

        it "should redirect to login page" do
          do_edit
          response.should be_success
        end
      end
    end
  end


  describe "Action Update" do
    def do_update
      put :update, :id => 1
    end

    context "when update calls" do
      context "when user is not log in" do
        before(:each) do
          session[:user_id] = nil
          User.stub(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_update
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "and the place doesn't exist" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(nil)
        end

        it "should redirect to login page" do
          do_update
          response.should redirect_to root_url
        end
      end

      context "and the current user is not the owner of the place" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(2)
        end

        it "should redirect to login page" do
          do_update
          response.should redirect_to root_url
        end
      end

      context "update_attributes return true" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(1)
          @place.stub(:user).and_return(@user)
          @place.stub(:hidden).and_return(false)
          @place.should_receive(:update_attributes).and_return(true)
          controller.stub(:expires_action)
        end

        it "should update the place" do
          do_update
          response.should redirect_to root_url
          flash.notice.should eq("Successfully updated.")
        end
      end

      context "update_attributes return false" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(1)
          @place.stub(:user).and_return(@user)
          @place.stub(:hidden).and_return(false)
          @place.should_receive(:update_attributes).and_return(false)
          controller.stub(:expires_action)
        end

        it "should render edit" do
          do_update
          response.should be_success
        end
      end
    end
  end

  describe "Action Destroy" do
    def do_destroy
      delete :destroy, :id => 1
    end

    context "when destroy calls" do
      context "when user is not log in" do
        before(:each) do
          session[:user_id] = nil
          User.stub(:find_by_id).with(nil).and_return(nil)
        end

        it "should redirect to login page" do
          do_destroy
          response.should redirect_to login_sessions_path
          flash.alert.should eq("Please log in")
        end
      end

      context "and the place doesn't exist" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(nil)
        end

        it "should redirect to login page" do
          do_destroy
          response.should redirect_to root_url
        end
      end

      context "destroy return true" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(1)
          @place.should_receive(:destroy).and_return(true)
        end

        it "should destroy the place" do
          do_destroy
          response.should redirect_to root_url
          flash.notice.should eq("This place has been deleted")
        end
      end

      context "destroy return false" do
        before(:each) do
          session[:user_id] = 1
          User.stub(:find_by_id).with(1).and_return(@user)
          Place.stub(:find_by_id).with("1").and_return(@place)
          @place.stub(:user_id).and_return(1)
          @place.should_receive(:destroy).and_return(false)
        end

        it "should not destroy the place" do
          do_destroy
          response.should redirect_to root_url
          flash.alert.should eq("This place can't be deleted because it has some pending deals.")
        end
      end
    end
  end
end
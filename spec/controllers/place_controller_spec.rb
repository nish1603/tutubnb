require 'spec_helper'

describe PlaceController do
	before do
		@user = double(User, :id => 1)
    @place = double(Place, :id => 1)
    @photo = double(Photo, :id => 1)
  end

	describe "Action New" do
	  def do_new
	  	get :new, :id => @user.id
	  end

	  context "when new calls" do
	    before do
	    	session[:user_id] = "1"
	      User.should_receive(:find_by_id).and_return(@user)
      end

	    it "should create a Place" do
        Place.should_receive(:new).and_return(@place)
        @place.stub(:build_detail).and_return(true)
        @place.stub(:build_address).and_return(true)
        @place.stub(:build_rules).and_return(true)
        2.times { @place.stub(:photos).and_return(@photo) 
                  @photo.stub(:build).and_return(true)}
        do_new
        response.should be_success
	    end
    end

    context "when new calls with nil id" do
      before do
        session[:user_id] = nil
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
      end

      it "should redirect to login" do
        do_new
        flash[:alert].should eq("Please log in")
        response.should redirect_to login_profile_index_path
      end
    end
  end

  describe "Action Create" do
    def do_create
      get :create, :id => @user.id
    end

    context "when create calls" do
      before do
        session[:user_id] = "1"
        params_place = nil
        User.should_receive(:find_by_id).and_return(@user)
      end

      it "should create a Place" do
        Place.should_receive(:new).and_return(@place)
        @place.user_id = session[:user_id]

        validate, notice = @place.stub(:check_commit).and_return(true, "Your place has been created.")

        do_create

        Place.stub(:save).with(:validate => validate).and_return(true)
        response.should redirect_to root_url
      end
    end

    # context "when new calls with nil id" do
    #   before do
    #     session[:user_id] = nil
    #     User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
    #   end

    #   it "should redirect to login" do
    #     do_new
    #     flash[:alert].should eq("Please log in")
    #     response.should redirect_to login_profile_index_path
    #   end
    # end
  end
end
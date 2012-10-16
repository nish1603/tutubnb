require 'spec_helper'

describe UserController do
	before do
		@user = double(User, :id => 1)
	end

	describe "Action Edit" do
	  def do_edit
	  	get :edit, :id => @user.id
	  end

	  context "when edit calls with valid id" do
	    before do
	    	session[:user_id] = "1"
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
	    end

	    it "should edit a User" do
        User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
        do_edit
        response.should be_success
        response.should render_template 'user/edit'
	    end
	  end

    context "when edit calls with nil id" do
      before do
        session[:user_id] = nil
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
      end

      it "should redirect to login" do
        do_edit
        flash[:alert].should eq("Please log in")
        response.should redirect_to login_profile_index_path
      end
    end

    context "when edit calls with wrong user" do
      before do
        session[:user_id] = "2"
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
      end

      it "should redirect to root_url" do
        do_edit
        response.should redirect_to root_url 
      end
    end
  end

  describe "Action Update" do
    def do_update
      put :update, :id => @user.id
    end

    context "when update calls" do
      before do
        session[:user_id] = "1"
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
      end

      it "details updated successfully" do
        User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
        @user.stub(:update_attributes).and_return(true)
        do_update
        flash[:notice].should eq("Details updated.")
        response.should redirect_to edit_user_path
      end
    end

    context "when update calls" do
      before do
        session[:user_id] = "1"
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
      end

      it "details not updated successfully" do
        User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
        @user.stub(:update_attributes).and_return(false)
        do_update
        response.should be_success
        flash[:error].should eq("Details not updated.")
        response.should render_template "user/edit"
      end
    end

    context "when update calls with nil id" do
      before do
        session[:user_id] = nil
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
      end

      it "should redirect to login" do
        do_update
        flash[:alert].should eq("Please log in")
        response.should redirect_to login_profile_index_path
      end
    end

    context "when update calls with wrong user" do
      before do
        session[:user_id] = "2"
        User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
      end

      it "should redirect to root_url" do
        do_update
        response.should redirect_to root_url 
      end
    end
  end
end
# require 'spec_helper'

# describe UsersController do
# 	before do
# 		@user = double(User, :id => 1)
# 	end

# 	describe "Action Edit" do
# 	  def do_edit
# 	  	get :edit, :id => @user.id
# 	  end

# 	  context "when edit calls with valid id" do
# 	    before do
# 	    	session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
# 	    end

# 	    it "should edit a User" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         do_edit
#         response.should be_success
#         response.should render_template 'user/edit'
# 	    end
# 	  end

#     context "when edit calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_edit
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when edit calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_edit
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Update" do
#     def do_update
#       put :update, :id => @user.id
#     end

#     context "when update calls" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "details updated successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         @user.stub(:update_attributes).and_return(true)
#         do_update
#         flash[:notice].should eq("Details updated.")
#         response.should redirect_to edit_user_path
#       end
#     end

#     context "when update calls" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "details not updated successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         @user.stub(:update_attributes).and_return(false)
#         do_update
#         response.should be_success
#         flash[:error].should eq("Details not updated.")
#         response.should render_template "user/edit"
#       end
#     end

#     context "when update calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_update
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when update calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_update
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Change DP" do
#     def do_change_dp
#       get :change_dp, :id => @user.id
#     end

#     context "when change_dp calls with valid id" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should change dp of a User" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         do_change_dp
#         response.should be_success
#         response.should render_template 'user/change_dp'
#       end
#     end

#     context "when change_dp calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_change_dp
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when change_dp calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_change_dp
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Update DP" do
#     def do_update_dp
#       put :update, :id => @user.id
#     end

#     context "when update_dp calls" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "dp updated successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         @user.stub(:update_attributes).and_return(true)
#         do_update_dp
#         flash[:notice].should eq("Details updated.")
#         response.should redirect_to edit_user_path
#       end
#     end

#     context "when update calls" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "dp not updated successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         @user.stub(:update_attributes).and_return(false)
#         do_update_dp
#         response.should be_success
#         flash[:error].should eq("Details not updated.")
#         response.should render_template "user/edit"
#       end
#     end

#     context "when update_dp calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_update_dp
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when update_dp calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_update_dp
#         response.should redirect_to root_url 
#       end
#     end
#   end


#   describe "Action Visits" do
#     def do_visits
#       get :visits, :id => @user.id
#     end

#     context "when visits calls" do
#       before do
#         session[:user_id] = "1"
#         @place = double(Place, :id => 1)
#         @deal = double(Deal, :id => 1)
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "shows visits successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         Deal.stub(:find_visits_of_user).and_return([@deal])
#         do_visits

#         response.should be_success
#       end
#     end

#     context "when visits calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_visits
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when visits calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_visits
#         response.should redirect_to root_url 
#       end
#     end
#   end


#   describe "Action Trips" do
#     def do_trips
#       get :trips, :id => @user.id
#     end

#     context "when trips calls" do
#       before do
#         session[:user_id] = "1"
#         @place = double(Place, :id => 1)
#         @deal = double(Deal, :id => 1)
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "shows trips successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         Deal.stub(:find_trips_of_user).and_return([@deal])
#         do_trips
#         response.should be_success
#       end
#     end

#     context "when trips calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_trips
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_sessions_path
#       end
#     end

#     context "when trips calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_trips
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Requested Trips" do
#     def do_requested_trips
#       get :requested_trips, :id => @user.id
#     end

#     context "when requested trips calls" do
#       before do
#         session[:user_id] = "1"
#         @place = double(Place, :id => 1)
#         @deal = double(Deal, :id => 1)
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "shows requested trips successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         Deal.stub(:find_requested_trips_of_user).and_return([@deal])
#         do_requested_trips
#         response.should be_success
#       end
#     end

#     context "when requested trips calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_requested_trips
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when requested trips calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_requested_trips
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Requests" do
#     def do_requests
#       get :requests, :id => @user.id
#     end

#     context "when requests calls" do
#       before do
#         session[:user_id] = "1"
#         @place = double(Place, :id => 1)
#         @deal = double(Deal, :id => 1)
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "shows requests successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         Deal.stub(:find_requested_trips_of_user).and_return([@deal])
#         do_requests
#         response.should be_success
#       end
#     end

#     context "when requests calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_requests
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_profile_index_path
#       end
#     end

#     context "when requests calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_requests
#         response.should redirect_to root_url 
#       end
#     end
#   end

#   describe "Action Destroy" do
#     def do_destroy
#       get :destroy, :id => @user.id
#     end

#     context "when destroy calls" do
#       before do
#         session[:user_id] = "1"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "user destroyed successfully" do
#         User.should_receive(:find_by_id).with(@user.id.to_s).and_return(@user)
#         do_destroy
#         @user.stub(:destroy).and_return(true)
#         response.should redirect_to root_url
#         # flash[:error].should eq("The account has been successfully deleted.") 
#       end
#     end

#     context "when requests calls with nil id" do
#       before do
#         session[:user_id] = nil
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(nil)
#       end

#       it "should redirect to login" do
#         do_destroy
#         flash[:alert].should eq("Please log in")
#         response.should redirect_to login_sessions_path
#       end
#     end

#     context "when requests calls with wrong user" do
#       before do
#         session[:user_id] = "2"
#         User.should_receive(:find_by_id).with(session[:user_id]).and_return(@user)
#       end

#       it "should redirect to root_url" do
#         do_destroy
#         response.should redirect_to root_url 
#       end
#     end
#   end
# end
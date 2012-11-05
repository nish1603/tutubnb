require 'spec_helper'

describe DisplayController do
  before do
	  @place1 = double(Place, :id => 1, :verified => true)
    @place2 = double(Place, :id => 2, :hidden => false)
  end

	describe "Action Show" do
	  def do_show
	  	get :show
	  end

	  context "when show calls" do
      context "with current user as admin" do
	      before do
          @places = [@place1]
          Place.stub(:hidden).with(false).and_return(@places)
        end

	      it "should render the places" do
          do_show
          response.should be_success
	      end
      end

      context "with current user as normal user" do
        before do
          @places = [@place2]
          Place.stub(:verified).with(true).and_return(@places)
        end

        it "should render the places" do
          do_show
          response.should be_success
        end
      end
   	end
  end
end
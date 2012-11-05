require 'spec_helper'

describe TagsController do
	before do
  	@tag1 = double(Tag, :id => 1, :tag => "fridge")
    @tag2 = double(Tag, :id => 2, :tag => "t.v.")
  end

	describe "Action Index" do
	  def do_index
	  	get :index
	  end

	  context "when new calls" do
	    before do
	      @tags = [@tag1, @tag2]
        Tag.stub(:tags_starting_with).and_return(@tags)
      end

	    it "should return the json of indexes" do
        do_index
        response.should be_success
	    end
    end
  end
end
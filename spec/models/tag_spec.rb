require 'spec_helper'

module TagSpecHelper
  def valid_tag_attributes
    {
      :tag => "fridge"
    }
  end
end

describe Tag do
  include TagSpecHelper
  
  before(:each) do
    @tag = Tag.new
  end

  it "can be instantiated" do
    @tag.should be_an_instance_of(Tag)
  end

  it "can be saved" do
    @tag.attributes = valid_tag_attributes
    @tag.save
    @tag.should have(0).errors_on(:tag)
  end

  it "tag should not be nil" do
    @tag.attributes = valid_tag_attributes.except(:tag)
    @tag.should have(1).errors_on(:tag)
    @tag.errors_on(:tag).should eq(["can't be blank"])
  end

  it "tag should be unique" do
    @tag2 = Tag.create(valid_tag_attributes)
    @tag.attributes = valid_tag_attributes
    @tag.should have(1).errors_on(:tag)
    @tag.errors_on(:tag).should eq(["has already been taken"])
  end
end
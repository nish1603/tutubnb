require 'spec_helper'

describe Place do
	it "can be instantiated" do
    Place.new.should be_an_instance_of(Place)
  end

  it "can be saved" do
    @place = Place.create(:title => 'happy home')
    @place.should_not be_persisted
  end
end
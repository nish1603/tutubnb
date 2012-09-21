require "test_helper"


class DealTest < ActiveSupport::TestCase
  fixtures :deals, :places, :details, :users

  test "deal price should be greater than zero" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => users(:one).email,
                    :gender => users(:one).gender)

    user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => users(:two).email,
                    :gender => users(:two).gender)

    user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    detail.save
    place.save

  	deal = Deal.new(:start_date => deals(:one).start_date,
  	                :end_date => deals(:one).end_date,
  	                :price => deals(:one).price,
  	                :guests => deals(:one).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save
  end
end
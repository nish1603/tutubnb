require "test_helper"


class DealTest < ActiveSupport::TestCase
  fixtures :deals, :places, :details, :users

  test "deal price should be greater than zero" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => 'adi@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:one).gender)

    assert user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => 'kd@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:two).gender)

    user2.wallet = 100000.00

    assert user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    assert place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    assert detail.save
    assert place.save

  	deal = Deal.new(:start_date => deals(:one).start_date,
  	                :end_date => deals(:one).end_date,
  	                :price => deals(:one).price,
  	                :guests => deals(:one).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save, "Price should be greater than zero"
  end


  test "deal start_date should be greater than or equal to current date" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => 'adi@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:one).gender)

    assert user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => 'kd@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:two).gender)

    user2.wallet = 100000.00

    assert user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    assert place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    assert detail.save
    assert place.save

    deal = Deal.new(:start_date => deals(:two).start_date,
                    :end_date => deals(:two).end_date,
                    :price => deals(:two).price,
                    :guests => deals(:two).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save, "Start date should be greater than or equal to current date."
  end

  test "deal end_date should be greater than or equal to start_date" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => 'adi@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:one).gender)

    assert user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => 'kd@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:two).gender)

    user2.wallet = 100000.00

    assert user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    assert place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    assert detail.save
    assert place.save

    deal = Deal.new(:start_date => deals(:three).start_date,
                    :end_date => deals(:three).end_date,
                    :price => deals(:three).price,
                    :guests => deals(:three).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save, "End date should be greater than or equal to current date."
  end

  test "number of guests should be smaller than accomodation" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => 'adi@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:one).gender)

    assert user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => 'kd@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:two).gender)

    user2.wallet = 100000.00

    assert user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    assert place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    assert detail.save
    assert place.save

    deal = Deal.new(:start_date => deals(:four).start_date,
                    :end_date => deals(:four).end_date,
                    :price => deals(:four).price,
                    :guests => deals(:four).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save, "No. of guests should be less than accomodation."
  end

  test "user can't buy deal more than his wallet" do

    user1 = User.new(:first_name => users(:one).first_name,
                    :last_name => users(:one).last_name,
                    :email => 'adi@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:one).gender)

    assert user1.save

    user2 = User.new(:first_name => users(:two).first_name,
                    :last_name => users(:two).last_name,
                    :email => 'kd@jmail.com',
                    :password => 'hellos',
                    :password_confirmation => 'hellos',
                    :gender => users(:two).gender)

    assert user2.save

    place = Place.new(:title => places(:one).title,
                      :description => places(:one).description,
                      :property_type => places(:one).property_type,
                      :room_type => places(:one).room_type,
                      :daily => places(:one).daily)

    place.user_id = user1.id

    assert place.save

    detail = Detail.new(:accomodation => details(:one).accomodation)
    detail.place_id = place.id
    assert detail.save
    assert place.save

    deal = Deal.new(:start_date => deals(:one).start_date,
                    :end_date => deals(:one).end_date,
                    :price => deals(:one).price,
                    :guests => deals(:one).guests)

    deal.user_id = user2.id
    deal.place_id = place.id

    assert deal.save, "you can't make a deal more than your wallet."
  end
end
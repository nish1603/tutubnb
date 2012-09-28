class DealObserver < ActiveRecord::Observer
  observe :deal
  def after_create(deal)
    owner = deal.place.user.first_name
    text = "A visitor wants to visit your place with name #{deal.place.name}. You can accept it here"
    #link = user_requests_url(owner.id)
	link = ''
	Notifier.notification(text, link, owner.email, owner, 'New Request').deliver
  end
end

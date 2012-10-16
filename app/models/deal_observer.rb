class DealObserver < ActiveRecord::Observer
  observe :deal

  def after_create(deal)
    owner = deal.place.user
    text = "A visitor wants to visit your place with name #{deal.place.title}. You can accept it here"
    #link = user_requests_url(owner.id)
    link = ''
    Notifier.notification(text, link, owner.email, owner.first_name, 'New Request').deliver
  end
  
end

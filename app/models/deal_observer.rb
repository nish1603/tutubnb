class DealObserver < ActiveRecord::Observer
  observe :deal

  def after_create(deal)
    text = "A visitor wants to visit your place with name #{deal.place.title}. You can accept it here"
    # link = requests_user_path(deal.owner.id)
    link = ''
    Notifier.delay(:queue => 'verification').notification(text, link, deal.owner.email, deal.owner.first_name, 'New Request')
  end
  
end

class Notifier < ActionMailer::Base
  default from: "tutubnb<OGadgetStore@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.verification.subject
  #
  def verification(link, sender_email, sender_name)
    @activation_link = link
    @sender_name = sender_name
    mail to: sender_email, subject: "Verification Mail"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.notification.subject
  #
  def notification(text, link, sender_email, sender_name, subject)
    @text = text
    @link = link
    @sender_name = sender_name
    mail to: sender_email, subject: subject
  end
end

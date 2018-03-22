class UserMailer < ApplicationMailer
  def registered(email, name, password)
    @email = email
    @name = name
    @password = password
    mail(to: email, subject: "Ihre Zugangsdaten für www.levumi.de")
  end

  def notify(email, name, text)
    @email = email
    @name = name
    @body = text
    mail(to: email, subject: "Neuigkeiten von Levumi")
  end
end

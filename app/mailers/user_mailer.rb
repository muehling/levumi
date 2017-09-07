class UserMailer < ApplicationMailer
  def registered(email, name, password)
    @email = email
    @name = name
    @password = password
    mail(to: email, subject: "Ihre Zugangsdaten für www.levumi.de")
  end
end

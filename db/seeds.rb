if Rails.env.development?
  u = User.create(email: "test@test.de", password: "123", password_confirmation: "123")
  u.groups.new(label: "Test")
  u.save
elsif Rails.env.production?

end

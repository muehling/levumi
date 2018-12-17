if Rails.env.development?
  u = User.create(email: "test@test.de", password: "123", password_confirmation: "123")
  5.times do |i|
    x = u.groups.create(label: "Klasse #{i}")
    5.times do |j|
      x.students.create(name: "Student #{i*5 + j}")
    end
  end
  u.groups.create(label: "Ein langer Klassenbezeichner", archive: true)
  u.save
  t = Test.create(name: "Test 1")
  t.assessments.create(group_id: 1)
  t.assessments.create(group_id: 2)
  t.save
  t = Test.create(name: "Test 2")
  t.assessments.create(group_id: 1)
  t.assessments.create(group_id: 3)
  t.save
elsif Rails.env.production?

end

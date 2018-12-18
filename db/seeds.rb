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

  a = Area.create(name: "Lesen/Schreiben", color: "red")
  c1 = a.competences.create(name: "Leseflüssigkeit", description: "Tests zur Leseflüssigkeit")
  c2 = a.competences.create(name: "Rechtschreibung", description: "Tests zur Rechtschreibung")
  a.save

  a = Area.create(name: "Mathematik", color: "blue")
  a.competences.create(name: "Zahlenstrahl", description: "Tests zur Arbeit mit dem Zahlenstrahl")
  a.save

  Area.create(name: "Verhalten", color: "black")

  t = c1.tests.create(name: "Test 1")
  c1. save
  t.assessments.create(group_id: 1)
  t.assessments.create(group_id: 2)
  t.save

  t = c1.tests.create(name: "Test 2")
  c1.save
  t.assessments.create(group_id: 1)
  t.assessments.create(group_id: 3)
  t.save

elsif Rails.env.production?

end

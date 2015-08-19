# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(email: "test@test.com", password: "123", password_confirmation: "123")
g = u.groups.build(name: "10a")
g.save
s = g.students.build(name: "Adam")
s.save
s = g.students.build(name: "Eva")
s.save

t = Test.create(name: "Lesetest", len: 2)
i = t.items.build(description: "haha", difficulty: 0.1, itemtype: 0)
i.save
i = t.items.build(description: "hoha", difficulty: 0.4, itemtype: 0)
i.save
i = t.items.build(description: "huho", difficulty: 0.7, itemtype: 0)
i.save
i = t.items.build(description: "laho", difficulty: 0.9, itemtype: 0)
i.save

a = g.assessments.build(test_id: t.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save
r = m.results.build(student: Student.find(1), results: {"1" => "1", "2" => "0"}, total: 0.5)
r.save
r = m.results.build(student: Student.find(2), results: {"1" => "0", "2" => "0"}, total: 0.0)
r.save

m = a.measurements.build(date: Date.today)
m.save
r = m.results.build(student: Student.find(1), results: {"1" => "1", "2" => "0"}, total: 0.5)
r.save

m = a.measurements.build(date: Date.tomorrow)
m.save
r = m.results.build(student: Student.find(1), results: {"1" => "1", "2" => "0"}, total: 0.5)
r.save
r = m.results.build(student: Student.find(2), results: {"1" => "1", "2" => "1"}, total: 1.0)
r.save

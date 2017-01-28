# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(email: "test@test.com", password: "123", password_confirmation: "123", capabilities: "admin")
g = u.groups.build(name: "10a")
g.save
s = g.students.build(name: "Adam")
s.save
s = g.students.build(name: "Eva")
s.save

t = TestSpeed.create(name: "Lesetest", len: 4, info: "Lesetest für die Grundschule, 1. Klasse", short_info:  "Lesetest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Lesen", archive: false, level: "Level 0", time: 60)
i = t.items.build(itemtext: "haha", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "hoha", difficulty: 0.4)
i.save
i = t.items.build(itemtext: "huho", difficulty: 0.7)
i.save
i = t.items.build(itemtext: "laho", difficulty: 0.9)
i.save

a = g.assessments.build(test_id: t.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save
r = m.results.build(student: Student.find(1), items: [1, 2], responses: [1,0], total: 0.5)
r.save
r = m.results.build(student: Student.find(2), items: [1, 2], responses:[0, 0], total: 0.0)
r.save

m = a.measurements.build(date: Date.today)
m.save
r = m.results.build(student: Student.find(1), items: [1, 2], responses:[1, 0], total: 0.5)
r.save

m = a.measurements.build(date: Date.tomorrow)
m.save
r = m.results.build(student: Student.find(1), items: [1, 2], responses:[1, 0], total: 0.5)
r.save
r = m.results.build(student: Student.find(2), items: [1, 2], responses:[1, 1], total: 1.0)
r.save


t1 = TestDictation.create(name: "DiktiertestByMe", len: 4, info: "Diktiertest für die Grundschule, 1. Klasse", short_info:  "Diktiertesttest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0")
i1 = t1.items.build(itemtext: "haha", difficulty: 0.1)
i1.save
i1 = t1.items.build(itemtext: "hoha", difficulty: 0.4)
i1.save
i1 = t1.items.build(itemtext: "huho", difficulty: 0.7)
i1.save
i1 = t1.items.build(itemtext: "laho", difficulty: 0.9)
i1.save

a1 = g.assessments.build(test_id: t1.id)
a1.save

m1 = a1.measurements.build(date: Date.yesterday)
m1.save
r1 = m1.results.build(student: Student.find(1), items: [1, 2], responses: [1,0], total: 0.5)
r1.save
r1 = m1.results.build(student: Student.find(2), items: [1, 2], responses:[0, 0], total: 0.0)
r1.save

m1 = a1.measurements.build(date: Date.today)
m1.save
r1 = m1.results.build(student: Student.find(1), items: [1, 2], responses:[1, 0], total: 0.5)
r1.save

m1 = a1.measurements.build(date: Date.tomorrow)
m1.save
r1 = m1.results.build(student: Student.find(1), items: [1, 2], responses:[1, 0], total: 0.5)
r1.save
r1 = m1.results.build(student: Student.find(2), items: [1, 2], responses:[1, 1], total: 1.0)
r1.save
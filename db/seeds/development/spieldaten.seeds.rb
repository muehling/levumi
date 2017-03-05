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

t = TestSpeed.create(name: "Lesetest", len: 4, info: "Lesetest für die Grundschule, 1. Klasse", short_info:  "Lesetest für die Grundschule, 1. Klasse",
                     subject: "Deutsch", construct: "Lesen", archive: false, level: "Level 0", time: 60)
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


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save





t = TestKeyboard.create(name: "Tasterturtest",len: 4, info: "Tastertur für die Grundschule, 1. Klasse", short_info:
    "Tasterturtest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0", time: 60, student_access:true)
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


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save


t = TestDictation.create(name: "Diktiertest", len: 6, info: "Diktiertest für die Grundschule, 1. Klasse", short_info:
    "Diktiertesttest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0", time: 60, student_access:true)
i = t.items.build(itemtext: "Flug", difficulty: 0.1, data: "Woerter/4_Flug.mp3")
i.save
i = t.items.build(itemtext: "einer", difficulty: 0.4, data: "Woerter/15_einer.mp3")
i.save
i = t.items.build(itemtext: "Keller", difficulty: 0.7, data: "Woerter/33_Keller.mp3")
i.save
i = t.items.build(itemtext: "Stärke", difficulty: 0.9, data: "Woerter/35_Stärke.mp3")
i.save
i = t.items.build(itemtext: "Sieb", difficulty: 0.9, data: "Woerter/41_Sieb.mp3")
i.save
i = t.items.build(itemtext: "Weihnachtsbaum", difficulty: 0.9, data: "Woerter/44_Weihnachtsbaum.mp3")
i.save

a = g.assessments.build(test_id: t.id)
a.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save


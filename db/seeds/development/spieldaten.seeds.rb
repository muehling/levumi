# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create(name: "Herr Soundso", email: "test@test.com", password: "123", password_confirmation: "123", capabilities: "admin", state:15, account_type: 2)
g = u.groups.build(name: "10a")
g.save
s = g.students.build(name: "Adam")
s.save
s = g.students.build(name: "Eva")
s.save


g = u.groups.build(name: "10b")
g.save
s = g.students.build(name: "Adam")
s.save
s = g.students.build(name: "Eva")
s.save





items = %w{
m
r
s
n
Ü
}

cbmN2 = Test.create(name: "Buchstaben erkennen", len: items.size, info: "", shorthand: "BE2", subject: "Deutsch",
                    construct: "Leseflüssigkeit", level: "Niveaustufe 2", type_info:"Screening", archive: false, student_access: false)

it = cbmN2.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN2.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


cbmN2.save

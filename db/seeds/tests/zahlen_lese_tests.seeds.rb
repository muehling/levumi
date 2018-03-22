# -*- encoding : utf-8 -*-

tN1 = Test.create(name: "Zahlen lesen", len: 11, info: "", shorthand: "ZL1", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 1",type_info:"Speed-Test", archive: false, student_access: false)

it = tN1.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

(0..10).to_a.each do |i|
  it = tN1.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = tN1.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


tN1.save

tN2 = Test.create(name: "Zahlen lesen", len: 21, info: "", shorthand: "ZL2", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 2", type_info:"Speed-Test", archive: false, student_access: false)

it = tN2.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

(0..20).to_a.each do |i|
  it = tN2.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = tN2.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


tN2.save

tN3 = Test.create(name: "Zahlen lesen", len: 80, info: "", shorthand: "ZL3", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 3", type_info:"Speed-Test", archive: false, student_access: false)

it = tN3.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

(21..100).to_a.each do |i|
  it = tN3.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = tN3.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

tN3.save

tN4 = Test.create(name: "Zahlen lesen", len: 100, info: "", shorthand: "ZL4", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 4", type_info:"Speed-Test", archive: false, student_access: false)

it = tN4.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

(101..1000).to_a.each do |i|
  it = tN4.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = tN4.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


tN4.save
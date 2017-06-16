# -*- encoding : utf-8 -*-

tN1 = TestSpeed.create(name: "Zahlen lesen", len: 11, info: "", short_info: "", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 1", archive: false)

(0..10).to_a.each do |i|
  it = tN1.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0)
  it.save
end

tN1.save

tN2 = TestSpeed.create(name: "Zahlen lesen", len: 21, info: "", short_info: "", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 2", archive: false)

(0..20).to_a.each do |i|
  it = tN2.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0)
  it.save
end

tN2.save

tN3 = TestSpeed.create(name: "Zahlen lesen", len: 80, info: "", short_info: "", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 3", archive: false)

(21..100).to_a.each do |i|
  it = tN3.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0)
  it.save
end

tN3.save

tN4 = TestSpeed.create(name: "Zahlen lesen", len: 100, info: "", short_info: "", time: 60, subject: "Mathematik", construct: "Zahlen lesen", level: "Niveaustufe 4", archive: false)

(101..1000).to_a.each do |i|
  it = tN4.items.build(itemtext: i.to_s, difficulty: 0, itemtype: 0)
  it.save
end

tN4.save
# -*- encoding : utf-8 -*-

tN1 = TestSpeed.create(name: "Zahlen lesen - N1", len: 11, info: "", short_info: "", time: 60, subject: "Mathematik")

(0..10).to_a.each do |i|
  it = tN1.items.build(itemtext: i.to_s, difficulty: 0)
  it.save
end

tN1.save

tN2 = TestSpeed.create(name: "Zahlen lesen - N2", len: 21, info: "", short_info: "", time: 60, subject: "Mathematik")

(0..20).to_a.each do |i|
  it = tN2.items.build(itemtext: i.to_s, difficulty: 0)
  it.save
end

tN2.save

tN3 = TestSpeed.create(name: "Zahlen lesen - N3", len: 80, info: "", short_info: "", time: 60, subject: "Mathematik")

(21..100).to_a.each do |i|
  it = tN3.items.build(itemtext: i.to_s, difficulty: 0)
  it.save
end

tN3.save

tN4 = TestSpeed.create(name: "Zahlen lesen - N4", len: 100, info: "", short_info: "", time: 60, subject: "Mathematik")

(101..1000).to_a.each do |i|
  it = tN4.items.build(itemtext: i.to_s, difficulty: 0)
  it.save
end

tN4.save
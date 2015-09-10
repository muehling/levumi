# -*- encoding : utf-8 -*-

cbmN1 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 1", len: 65, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = ["l", "n", "r", "m", "f", "s", "L", "N", "R", "M", "F", "S"]
vowels = ["a", "e", "i", "o", "u"]

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN1.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
cbmN1.save


cbmN2 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 2", len: 65, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = ["h", "ch", "w", "p", "t", "k", "b", "d", "g", "H", "Ch", "W", "P", "T", "K", "B", "D", "G"]
vowels = ["a", "e", "i", "o", "u", "ei", "au", "eu"]

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN2.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
cbmN2.save

cbmN3 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 3", len: 65, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = ["j", "z", "v", "sch"]
consonantes_up = ["J", "Z", "V", "Sch"]
vowels = ["a", "e", "i", "o", "u", "ei", "au", "eu", "ö", "ä", "ü"]
vowels_up = ["A", "E", "I", "O", "U", "Ei", "Au", "Eu", "Ö", "Ä", "Ü"]

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN3.items.build(itemtext: c+v, difficulty: 0)
    i.save
    i = cbmN3.items.build(itemtext: v+c, difficulty: 0)
    i.save
  end
end
consonantes_up.each do |c|
  vowels.each do |v|
    i = cbmN3.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
vowels_up.each do |c|
  consonantes.each do |v|
    i = cbmN3.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
vowels.each do |v|
  i = cbmN3.items.build(itemtext: "qu"+v, difficulty: 0)
  i.save
  i = cbmN3.items.build(itemtext: "Qu"+v, difficulty: 0)
  i.save
end
vowels.each do |v|
  if (v != "u" && v != "U")
    i = cbmN3.items.build(itemtext: "qu"+v, difficulty: 0)
    i.save
    i = cbmN3.items.build(itemtext: "Qu"+v, difficulty: 0)
    i.save
  end
end
(vowels + vowels_up).each do |v|
  i = cbmN3.items.build(itemtext: v+"tz", difficulty: 0)
  i.save
  i = cbmN3.items.build(itemtext: v+"ck", difficulty: 0)
  i.save
end
cbmN3.save

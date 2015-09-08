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
vowels = ["a", "e", "i", "o", "u", "ei", "au"]

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN2.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
cbmN2.save


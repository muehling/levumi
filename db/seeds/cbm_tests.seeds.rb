# -*- encoding : utf-8 -*-

cbmN1 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 1", len: 65, info: "(c) Dr. Diehl _ ISER, Uni-Rostock", time: 60)

consonantes = ["l", "n", "r", "m", "f", "s", "L", "N", "R", "M", "F", "S"]
vowels = ["a", "e", "i", "o", "u", "au", "ei"]

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN1.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end

cbmN1.save
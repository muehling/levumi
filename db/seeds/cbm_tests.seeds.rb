# -*- encoding : utf-8 -*-

cbmN1 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 1", len: 60, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = %w{f, l, m, n, r, s, F, L, M, N, R, S}
vowels = %w{a, e, i, o, u}

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN1.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
cbmN1.save


cbmN2 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 2", len: 65, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = %w{b, d, g, h, k, p, t, w, ch, B, D, G, H, K, P, T, W, Ch}
vowels = %w{a, e, i, o, u, au, ei, eu}

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN2.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
cbmN2.save

cbmN3 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 3", len: 100, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = %w{j, v, z, sch}
consonantes_up = %w{J, V, Z, Sch}
vowels = %w{a, e, i, o, u, au, ei, eu, ä, ö, ü}
vowels_up = %w{A, E, I, O, U, Au, Ei, Eu, Ä, Ö, Ü}

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN3.items.build(itemtext: c+v, difficulty: 0)
    i.save
    if c != "j"
      i = cbmN3.items.build(itemtext: v+c, difficulty: 0)
      i.save
    end
  end
end
consonantes_up.each do |c|
  vowels.each do |v|
    i = cbmN3.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
vowels_up.each do |v|
  consonantes.each do |c|
    if c != "j"
      i = cbmN3.items.build(itemtext: v+c, difficulty: 0)
      i.save
    end
  end
end
vowels.each do |v|
  if v != "u"
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

cbmN4 = TestSpeed.create(name: "CBM Silben lesen - Niveaustufe 4", len: 100, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

consonantes = %w{b, d, f, g, h, k, l, m, n, p, r, s, t, w, ch, B, D, F, G, H, K, L, M, N, P, R, S, T, W, Ch}
vowels = %w{a, e, i, o, u, au, ei, eu}
extras = %w{ab, ach, ack, an, am, asch, auch, auf, ech, eck, eich, eil, ein, eis, el, em, en, er, es, esch, euch, ich, ick, im, in, isch, och, ock, osch, uch, um, un, usch}

consonantes.each do |c|
  vowels.each do |v|
    i = cbmN4.items.build(itemtext: c+v, difficulty: 0)
    i.save
  end
end
extras.each do |e|
  i = cbmN4.items.build(itemtext: e, difficulty: 0)
  i.save
end
cbmN4.save
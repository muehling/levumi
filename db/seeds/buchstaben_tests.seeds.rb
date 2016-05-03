# -*- encoding : utf-8 -*-
items = %w{
m
r
s
n
f
l
a
e
i
o
u
h
w
p
t
d
au
ei
ch
k
b
sch
g
}

cbmN1 = TestCBM.create(name: "Buchstaben erkennen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 300, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1")

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN1.save



items = %w{
m
r
s
n
f
l
a
e
i
o
u
h
w
p
t
d
au
ei
ch
k
b
sch
g
j
v
ß
sp
st
ck
z
qu
x
y
eu
ä
ö
ü
}

cbmN2 = TestCBM.create(name: "Buchstaben erkennen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 300, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2")

items.each do |i|
  it = cbmN2.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN2.save


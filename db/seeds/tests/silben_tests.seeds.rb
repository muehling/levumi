# -*- encoding : utf-8 -*-
items = %w{
ma
Mu
le
mi
La
Mo
lu
Lo
me
li
lo
Ma
mo
Li
Lu
Me
mu
Mi
Le
la
}

cbmN0 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL0", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 0", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN0.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN0.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN0.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN0.save


items = %w{
fo
ra
Le
Su
na
Ro
si
Fe
Ni
mu
fu
ri
Sa
no
fa
so
Lu
Ne
Mi
Re
sa
le
Nu
ro
se
Lo
Fa
mi
Se
lu
fe
Ma
Li
me
ni
Ru
ma
Fo
nu
So
la
Mu
Ri
lo
su
Fi
ne
La
Si
Me
ru
Mo
Ra
li
No
re
mo
fi
Fu
Na
}

cbmN1 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL1", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN1.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN1.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN1.save




items = %w{
del
ho
Rei
Wu
nen
pi
en
lei
Tau
sen
fer
men
de
wa
Dau
Ra
Lei
hu
Sau
wei
da
hen
Pi
we
hau
Tei
De
pa
fen
der
Wei
Hu
po
Sei
We
tau
du
fei
Ho
Rau
sei
wu
Da
hei
Po
rau
Wa
Hei
Du
sau
len
rei
Do
ha
tei
Hau
ra
lau
Ha
dei
mer
dau
Pa
tei
do
}

cbmN2a = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL2a", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN2a.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2a.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN2a.save





items = %w{
Gi
scha
bo
cher
gau
bel
ku
cho
Ka
Schei
chen
Ba
gel
sche
Go
Ke
bi
kei
chu
Schau
ber
Ki
gen
Schu
chei
Bu
kau
Ga
che
schau
Bi
gei
Sche
go
Kei
chau
bu
ki
ga
scho
Ku
Scha
ben
gu
schei
ba
kau
cha
Ko
schu
Bo
ke
Scho
gi
ka
Gu
ko
}

cbmN2b = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL2b", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN2b.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2b.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


cbmN2b.save





items = %w{
schü
beu
Vi
spa
jä
hex
Zö
stau
Qui
ty
auch
Feu
spu
Ze
jo
Stö
quä
ßen
Schö
spei
Zei
stö
Vei
ju
Keu
xi
Py
Stä
Zi
ße
Auch
Jau
schä
qui
Eu
zü
Spi
Vö
Stei
Zä
vei
ßer
Stau
Qua
Spei
ja
Schä
Hex
Zeu
geu
Spa
Schü
Ju
py
zä
Stu
Beu
zau
sta
je
Quä
Ty
Spe
va
Zu
Euch
keu
Za
Vo
neu
Jo
sti
schö
eu
Spä
zei
stä
Spü
zi
feu
Jä
Sto
scheu
vö
Zü
Sti
seu
spä
Ste
Neu
zeu
sto
spi
Ja
euch
spe
qua
Zau
Je
Va
vo
stu
zö
Seu
stei
spü
ste
vi
za
Scheu
jau
Spu
zu
Sta
ze
cheu
}

cbmN3 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL3", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN3.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN3.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN3.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN3.save




items = %w{
kli
tra
Schlo
Ble
spru
Dra
frei
bro
Krau
pleu
glu
Bli
kreu
Schla
Drei
glo
bra
Fre
klu
Spre
plau
spro
Kra
brei
Plo
klau
Fro
glei
Schli
Tru
spri
dra
plu
drau
Freu
gla
Fri
kle
Spra
schle
Trei
bri
Kru
blo
Trau
Bla
schlu
krei
Spru
Klo
Frau
pla
Dro
bre
gli
Brau
Kro
schla
Tre
dri
glau
Pli
blu
fro
Krei
Plau
Gle
kra
Kli
Pleu
schli
spre
Dru
blau
bru
trau
plo
freu
Blu
tro
Schle
brau
Pla
Kreu
Glo
fri
Drau
trei
bli
Brei
kro
Tra
pli
krau
spra
gle
Blau
Schlu
Gla
Bro
Klau
Frei
dro
tru
Tri
klo
ple
schlo
Dri
bla
tre
frau
Glau
kru
ble
Glu
Bru
Glei
Klu
Tro
fre
Spri
Bre
Plu
Gli
Spro
Blo
dru
Bra
Kle
Bri
Ple
drei
tri
}

cbmN4 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "SL4", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN4.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN4.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN4.save
# -*- encoding : utf-8 -*-
items = %w{
la
La
le
Le
li
Li
lo
Lo
lu
Lu
ma
Ma
me
Me
mi
Mi
mo
Mo
mu
Mu
}

cbmN0 = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 0", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN0.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN0.save





items = %w{
Fa
fa
Fe
fe
Fi
fi
Fo
fo
Fu
fu
la
La
le
Le
li
Li
lo
Lo
lu
Lu
ma
Ma
me
Me
mi
Mi
mo
Mo
mu
Mu
Na
na
Ne
ne
Ni
ni
No
no
Nu
nu
ra
Ra
re
Re
ri
Ri
ro
Ro
ru
Ru
Sa
sa
Se
se
Si
si
So
so
Su
su
}

cbmN1 = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 1", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN1.save




items = %w{
da
Da
dau
Dau
de
De
del
der
do
Do
Du
du
dei
fei
en
fen
fer
ha
Ha
hau
Hau
hei
Hei
hen
ho
Ho
hu
Hu
lau
Lau
lei
Lei
len
men
mer
nen
pa
Pa
pi
Pi
po
Po
ra
Ra
rau
Rau
rei
Rei
sau
Sau
Sei
sei
sen
seu
Seu
tau
Tau
tei
Tei
wa
Wa
we
We
wei
Wei
wu
Wu
}

cbmN2a = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 2a", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN2a.save





items = %w{
bel
ben
ber
bo
Bo
bi
bi
bu
Bu
ba
Ba
che
chen
cher
cha
chu
chau
chei
cho
ga
Ga
gel
gen
gu
Gu
go
Go
gi
Gi
gau
gei
ka
Ka
kau
Kau
ke
Ke
keu
Keu
Ki
ki
ko
Ko
ku
Ku
kei
Kei
scha
Scha
schau
Schau
sche
Sche
schei
Schei
schu
Schu
scho
Scho
}

cbmN2b = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 2b", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN2b.save





items = %w{
auch
Auch
euch
Euch
hex
Hex
ja
Ja
jä
Jä
jau
Jau
je
Je
jo
Jo
ju
Ju
Py
py
qua
Qua
quä
Quä
qui
Qui
schä
Schä
schö
Schö
schü
Schü
spa
Spa
spä
Spä
spe
Spe
spei
Spei
spi
Spi
spu
Spu
spü
Spü
ße
ßen
ßer
sta
Sta
stä
Stä
stau
Stau
Ste
ste
stei
Stei
sti
Sti
sto
Sto
stö
Stö
stu
Stu
Ty
ty
va
Va
vei
Vei
vi
Vi
vo
Vo
vö
Vö
xi
za
Za
zä
Zä
zau
Zau
ze
Ze
zei
Zei
zeu
Zeu
Zi
zi
zö
Zö
Zu
zu
zü
Zü
feu
Feu
cheu
beu
Beu
geu
neu
Neu
scheu
Scheu
eu
Eu
}

cbmN3 = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 3", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN3.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN3.save




items = %w{
Bla
bla
blau
Blau
Ble
ble
Bli
bli
Blo
blo
Blu
blu
bra
Bra
Brau
brau
bre
Bre
Brei
brei
Bri
bri
Bro
bro
Bru
bru
dra
Dra
Drau
drau
Drei
drei
Dri
dri
Dro
dro
Dru
dru
Frau
frau
Fre
Fre
frei
Frei
Freu
freu
Fri
fri
Fro
fro
Gla
gla
Glau
glau
Gle
gle
Glei
glei
Gli
gli
Glo
glo
Glu
glu
klau
Klau
Kle
kle
Kli
kli
Klo
klo
Klu
klu
Kra
kra
Krau
krau
Krei
krei
Kreu
kreu
Kro
kro
Kru
kru
Pla
pla
Plau
plau
ple
Ple
pleu
Pleu
Pli
pli
Plo
plo
Plu
plu
Schla
schla
Schle
schle
Schli
schli
Schlo
schlo
Schlu
schlu
spra
Spra
Spre
spre
spri
Spri
Spro
spro
spru
Spru
Tra
tra
Trau
trau
Tre
tre
Trei
trei
Tri
tri
Tro
tro
Tru
tru
}

cbmN4 = TestCBM.create(name: "CBM Silben lesen - Niveaustufe 4", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", category: "Silben lesen")
items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN4.save
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
M
R
S
N
F
L
A
E
I
O
U
H
W
P
T
D
Au
Ei
Ch
K
B
Sch
G
}

cbmN1 = Test.create(name: "Buchstaben erkennen", len: items.size, info: "", shorthand: "BE1", subject: "Deutsch", construct: "Leseflüssigkeit", 
	level: "Niveaustufe 1", archive: false, type_info:"Screening",  student_access: false)
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
z
qu
x
y
eu
ä
ö
ü
M
R
S
N
F
L
A
E
I
O
U
H
W
P
T
D
Au
Ei
Ch
K
B
Sch
G
J
V
Sp
St
Z
Qu
X
Y
Eu
Ä
Ö
Ü
}

cbmN2 = Test.create(name: "Buchstaben erkennen", len: items.size, info: "", shorthand: "BE2", subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2", type_info:"Screening", archive: false, student_access: false)

it = cbmN2.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN2.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save


cbmN2.save
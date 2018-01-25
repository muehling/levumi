



# Number to position for numbers 0 to 10

items = %w{
9
2
1
5
7
6
4
8
3
}
toleranceValue = 1 # It means 5 on the left and 5 on the right side (totally 10)
lineLength = 10

math = Test.create(name: "Position finden ", info:"Number to position 0-10", shorthand: "PF1", len: 11, time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 1 (0-10)")

it = math.items.build(itemtext: "Hallo", itemtype: -1, shorthand: 10, itemview: "items/studentbased/mathetest/1halloNP")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentNP")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save






# Number to position for numbers 0 to 20

items= %w{
7
6
3
17
16
5
1
2
19
10
18
13
8
4
9
14
15
11
12
}

toleranceValue = 1 ;
lineLength = 20;

math = Test.create(name: "Position finden ", info:"Number to position 0-20", shorthand: "PF2", len: 21, time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 2 (0-20)")

it = math.items.build(itemtext: "Hallo", itemtype: -1, shorthand: 20, itemview: "items/studentbased/mathetest/1halloNP")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentNP")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save






# Number to position for numbers 0 to 100

items = %w{
22
59
98
53
45
9
86
84
15
13
5
27
32
77
67
61
40
91
73
36
}
toleranceValue = 5 # It means 5 on the left and 5 on the right side (totally 10)
lineLength = 100

math = Test.create(name: "Position finden ", info:"Number to position 0-100",shorthand: "PF3", len: 22, time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 3 (0-100)")

it = math.items.build(itemtext: "Hallo", shorthand: 100, itemtype: -1, itemview: "items/studentbased/mathetest/1halloNP")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentNP")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save














######################################## Position to number Tests #######################################


# position to number for numbers 0 to 10

items = %w{
1
3
4
9
7
6
8
2
5
}
toleranceValue = 1 # It means 5 on the left and 5 on the right side (totally 10)
lineLength = 10

math = Test.create(name: "Zahl finden ", info:"Position to number 0-10",shorthand: "ZF1", len: 11, time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 1 (0-10)")

it = math.items.build(itemtext: "Hallo", itemtype: -1, shorthand: 10, itemview: "items/studentbased/mathetest/1halloPN")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentPN")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save


# Position to number for numbers 0 to 20

items= %w{
3
19
9
7
18
10
4
2
6
17
14
11
8
13
5
15
16
1
12
}

toleranceValue = 1 ;
lineLength = 20;

math = Test.create(name: "Zahl finden ", info:"Position to number 0-20", len: 21,shorthand: "ZF2", time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 2 (0-20)")

it = math.items.build(itemtext: "Hallo", itemtype: -1, shorthand: 20, itemview: "items/studentbased/mathetest/1halloPN")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentPN")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save




# Position to number for numbers 0 to 100

items = %w{
69
94
72
12
92
88
54
24
83
3
14
62
8
44
30
75
28
47
33
50
}
toleranceValue = 5 # It means 5 on the left and 5 on the right side (totally 10)
lineLength = 100

math = Test.create(name: "Zahl finden ", info:"Position to number 0-100",shorthand: "ZF3", len: 22, time: 180, subject: "Mathematik", construct: "Zahlenstrahl", student_access: true, archive: false, level: "Niveaustufe 3 (0-100)")

it = math.items.build(itemtext: "Hallo", itemtype: -1, shorthand: 100, itemview: "items/studentbased/mathetest/1halloPN")
it.save

i=0
while i<items.length do
	it = math.items.build(itemtext: lineLength,shorthand: items[i], difficulty: toleranceValue, itemtype: 0, itemview: "items/studentbased/mathetest/2testItemStudentPN")
	it.save
	i= i+1
end

it = math.items.build(itemtext: "Ende", itemtype: 1, itemview: "items/studentbased/mathetest/3ende") 
it.save
math.save
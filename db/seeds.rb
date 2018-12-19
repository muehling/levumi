if Rails.env.development?

  #Spieldaten anlegen

  users = [
      {email: "admin@admin.de", password: "123", password_confirmation: "123", capabilities: "admin"} ,
      {email: "user@user.de", password: "123", password_confirmation: "123", capabilities: ""}
  ]

  groups = [
      [
          {label: "Klasse 1"}, {label: "Klasse 2"}, {label: "Klasse 3"}, {label: "Klasse 4"}, {label: "Klasse 5"},
          {label: "Ein langer Klassenbezeichner", archive: true}
      ],
      [
          {label: "Klasse 1"}
      ]
  ]

  students = [
      [
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}, {name: "Student 4"}, {name: "Student 5"}
          ],
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}, {name: "Student 4"}, {name: "Student 5"}
          ],
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}, {name: "Student 4"}, {name: "Student 5"}
          ],
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}, {name: "Student 4"}, {name: "Student 5"}
          ],
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}, {name: "Student 4"}, {name: "Student 5"}
          ],
          [
              {name: "Adam"}, {name: "Eva"}
          ]
      ],
      [
          [
              {name: "Student 1"}, {name: "Student 2"}, {name: "Student 3"}
          ]
      ]
  ]

  areas = [
      {name: "Lesen/Schreiben", color: "red"},
      {name: "Mathematik", color: "blue"},
      {name: "Verhalten", color: "black"}
  ]

  competences = [
      [
          {name: "Leseflüssigkeit", description: "Tests zur Leseflüssigkeit"},
          {name: "Rechtschreibung", description: "Tests zur Rechtschreibung"}
      ],
      [
          {name: "Zahlenstrahl", description: "Tests zur Arbeit mit dem Zahlenstrahl"}
      ],
      [

      ]
  ]

  tests = [
      [
          [
              {name: "Test 1", level: "Level 1"},
              {name: "Test 1", level: "Level 2"},
              {name: "Test 1", level: "Level 3"},
              {name: "Test 2", level: "Level 1"}
          ],
          [

          ]
      ],
      [
          [

          ]
      ],
      [

      ]
  ]

  users.each_with_index do |u, i|
    user = User.create(u)
    groups[i].each_with_index do |g, j|
      group = user.groups.create(g)
      students[i][j].each do |s|
        group.students.create(s)
      end
      group.save
    end
    user.save
  end

  areas.each_with_index do |a, i|
    area = Area.create(a)
    competences[i].each_with_index do |c, j|
      competence = area.competences.create(c)
      tests[i][j].each do |t|
        test = competence.tests.create(t)
        test.assessments.create(group: Group.find(1))
        test.save
      end
      competence.save
    end
    area.save
  end

elsif Rails.env.production?
  #Admin Account anlegen
end

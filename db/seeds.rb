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
      {name: "Deutsch", color: "red"},
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
      []
  ]

  families = [
      [
          [
              {name: "Test 1", description: "Silbenlesen"},
              {name: "Test 2", description: "Wortlesen"}
          ],
          []
      ],
      [
          []
      ],
      [
           []
      ]
  ]

  tests = [
      [
          [
             [
                 {level: "Level 1"},
                 {level: "Level 2"}
             ],
             [
                 {level: "Niveaustufe 1"}
             ]
          ]
      ],
      [
          []
      ],
      []
  ]

  assessments = [
      {
          group_id: 1,
          test_id: 1
      },
      {
          group_id: 1,
          test_id: 2
      },
      {
          group_id: 2,
          test_id: 1
      }
  ]

  results = [
      [
          {student_id: 1}, {student_id: 2}, {student_id: 3}
      ],
      [],
      []
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
      families[i][j].each_with_index do |f, k|
        family = competence.test_families.create(f)
        tests[i][j][k].each_with_index do |t, l|
          test = family.tests.create(t)
          test.save
        end
        family.save
      end
      competence.save
    end
    area.save
  end

  assessments.each_with_index do |a, i|
    a = Assessment.create(a)
    results[i].each do |r|
      a.results.create(r)
    end
    a.save
  end

elsif Rails.env.production?
  #Admin Account anlegen
end

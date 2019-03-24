#if Rails.env.development?

  #Spieldaten anlegen

  users = [
      {email: "admin@admin.de", password: "123", password_confirmation: "123", capabilities: "admin", account_type: 1, state: 1, tc_accepted: DateTime.now, intro_state: 4} ,
      {email: "user@user.de", password: "123", password_confirmation: "123", capabilities: "", account_type: 0, state: 1}
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
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}', gender: 0, sen: 0, migration: 0},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ],
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ],
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ],
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ],
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ],
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
          ]
      ],
      [
          [
              {name: '{"iv":"AQC/DPc+k/vLTL7tkJH87Q==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"ylxAnM2YxsoBw5uy"}'},
              {name: '{"iv":"IHeQV3xdT1+xGjTBVUQHvw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"g0w2SBoi72E=","ct":"W0NL/wvkjA3clT0="}'}
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
                 {level: "Level 1", student_test: false},
                 {level: "Level 2", student_test: true}
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

  users.each_with_index do |u, i|
    user = User.create(u)
    groups[i].each_with_index do |g, j|
      group = user.groups.create(g)
      students[i][j].each do |s|
        x = group.students.create(s)
        if (i == 0 && j == 0 && x.name.starts_with?('{"iv":"A'))
          x.login = 'test'
          x.save
        end
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

  #Spieltest anlegen (später per Upload)
  Test.import('db/example_tests/user_based_test/test.zip', false, true )
  Test.import('db/example_tests/student_based_test/test.zip', false, true )

  #Spielergebnisse anlegen
  a1 = Assessment.create(group_id: 2, test_id: Test.find_by_shorthand('Ex_U_1').id)
  a2 = Assessment.create(group_id: 2, test_id: Test.find_by_shorthand('Ex_S_1').id)
  Group.find(2).students.each do |s|
    7.times do |i|
      if (rand > 0.3)
        r = a1.results.build(student_id: s.id, test_date: DateTime.now-7*(6-i), results: {'Übersicht': rand, 'Detailauswertung': {'Katzen': rand*3, 'Vögel': rand*3}})
        r.save
      end
    end
    a2.results.create(student_id: s.id, expires_on: DateTime.now + 3)
  end

#elsif Rails.env.production?
  #Admin Account anlegen
#end

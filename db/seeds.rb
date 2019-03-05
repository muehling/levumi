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

  assessments = [
      {
          group_id: 2,
          test_id: 1
      },
      {
          group_id: 2,
          test_id: 2
      },
      {
          group_id: 3,
          test_id: 1
      }
  ]

  results = [
      [
          {student_id: 1}, {student_id: 2}, {student_id: 1}
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
      t = a.results.create(r)
      t.save   # wg. test_week
    end
    a.save
  end

  #Spieltest anlegen (später per Upload)
  test = Test.find(1)
  vals = ActiveSupport::JSON.decode(File.read('db/example_tests/user_based_test/test.json'))
  test.update_attributes(vals)
  test.entry_point.attach(io: File.open('db/example_tests/user_based_test/test.html'), filename: 'test.html', content_type: 'text/html')
  Dir.foreach('db/example_tests/user_based_test/media') do |filename|
    if filename == '.' || filename == '..'
      next
    end
    test.media_files.attach(io: File.open('db/example_tests/user_based_test/media/' + filename), filename: filename)
  end
  Dir.foreach('db/example_tests/user_based_test/scripts') do |filename|
    if filename == '.' || filename == '..'
      next
    end
    test.script_files.attach(io: File.open('db/example_tests/user_based_test/scripts/' + filename), filename: filename, content_type: 'text/javascript')
  end
  Dir.foreach('db/example_tests/user_based_test/styles') do |filename|
    if filename == '.' || filename == '..'
      next
    end
    test.style_files.attach(io: File.open('db/example_tests/user_based_test/styles/' + filename), filename: filename, content_type: 'text/css')
  end


#elsif Rails.env.production?
  #Admin Account anlegen
#end

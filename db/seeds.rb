#if Rails.env.development?

  #Spieldaten anlegen

  users = [
      {email: "admin@admin.de", password: "123", password_confirmation: "123", capabilities: "admin", account_type: 1, state: 1, tc_accepted: DateTime.now, intro_state: 4} ,
      {email: "user@user.de", password: "123", password_confirmation: "123", capabilities: "", account_type: 0, state: 1}
  ]

  groups = [
      {label: "Klasse 1"},
      {label: "Klasse 2"},
      {label: "Klasse 3"},
      {label: "Ein langer Klassenbezeichner", archive: true},
  ]

  #Key für "Klasse 1", "Klasse 3", "Ein langer Klassenbezeichner" => "test", Key für "Klasse 2" => "klasse"
  group_shares = [
      {user_id: 1, group_id: 3, owner: true, read_only: false, key: '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'},
      {user_id: 1, group_id: 4, owner: true, read_only: false, key: '{"iv":"zqS4X5C6jvq4Kh4FVIcXxw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"GnNuOCPp3nkcUzzWFks="}'},
      {user_id: 1, group_id: 5, owner: true, read_only: false, key: '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'},
      {user_id: 1, group_id: 6, owner: true, read_only: false, key: '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'},
      {user_id: 2, group_id: 3, owner: false, read_only: true, key: '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'},
      {user_id: 2, group_id: 4, owner: false, read_only: false, key: '{"iv":"zqS4X5C6jvq4Kh4FVIcXxw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"GnNuOCPp3nkcUzzWFks="}'}
  ]

  #"Adamn" und "Eva", verschlüsselt mit Key für Klasse 1
  students = [
      {name: '{"iv":"WCm9XH6cM7s7e3ea4cZB3w==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"nPcGN4uGo9Y=","ct":"MbW6TZm0FKF9pSb1"}', gender: 0, sen: 0, migration: 0},
      {name: '{"iv":"6QrHF209McMuDUfcMP3z4g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"nPcGN4uGo9Y=","ct":"ErP3QkJVO3qUbp0="}'}
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

  users.each do |u|
    User.create(u)
  end

  groups.each_with_index do |g, i|
    group = Group.create(g)
    if (i == 0)
      students.each_with_index do |s, j|
        x = group.students.create(s)
        if (j == 0)
          x.login = 'test'
          x.save
        end
      end
    end
    group.save
  end

  group_shares.each do |c|
    GroupShare.create(c)
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
  a1 = Assessment.create(group_id: 3, test_id: Test.find_by_shorthand('Ex_U_1').id)
  a2 = Assessment.create(group_id: 3, test_id: Test.find_by_shorthand('Ex_S_1').id)
  Group.find(3).students.each do |s|
    7.times do |i|
      if (rand > 0.3)
        r = a1.results.build(student_id: s.id, test_date: DateTime.now-7*(6-i), results: {'Übersicht': rand, 'Detailauswertung': {'Katzen': rand*3, 'Vögel': rand*3}})
        r.save
        a2.results.create(student_id: s.id, expires_on: DateTime.now + i)
      end
    end
  end

#elsif Rails.env.production?
  #Admin Account anlegen
#end

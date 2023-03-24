if Rails.env.development?
  #Spieldaten anlegen

  users = [
    {
      email: 'admin@admin.de',
      password: '123',
      password_confirmation: '123',
      capabilities: 'admin',
      account_type: 1,
      state: 1,
      tc_accepted: DateTime.now,
      intro_state: 4
    },
    {
      email: 'user@user.de',
      password: '123',
      password_confirmation: '123',
      capabilities: '',
      account_type: 0,
      tc_accepted: DateTime.now,
      state: 1,
      intro_state: 1
    }
  ]

  groups = [
    {
      label: 'Klasse 1',
      auth_token:
        '{"iv":"xnRCex00TPDU4qy/6SOuXQ==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"61xDj17EoaA=","ct":"xWJ5Cck4QvJ77J++"}'
    },
    {
      label: 'Klasse 2',
      auth_token:
        '{"iv":"KIvFNdFKL3q7vV6KBqY4gw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"zrMNMViJZok=","ct":"XZp0uEjIvPddSDFP5po="}'
    },
    {
      label: 'Klasse 3',
      auth_token:
        '{"iv":"xnRCex00TPDU4qy/6SOuXQ==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"61xDj17EoaA=","ct":"xWJ5Cck4QvJ77J++"}'
    },
    {
      label: 'Ein langer Klassenbezeichner',
      archive: true,
      auth_token:
        '{"iv":"xnRCex00TPDU4qy/6SOuXQ==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"61xDj17EoaA=","ct":"xWJ5Cck4QvJ77J++"}'
    }
  ]

  #Key für "Klasse 1", "Klasse 3", "Ein langer Klassenbezeichner" => "test", Key für "Klasse 2" => "klasse"
  group_shares = [
    {
      user_id: 1,
      group_id: 1,
      owner: true,
      read_only: false,
      key:
        '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'
    },
    {
      user_id: 1,
      group_id: 2,
      owner: true,
      read_only: false,
      key:
        '{"iv":"zqS4X5C6jvq4Kh4FVIcXxw==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"GnNuOCPp3nkcUzzWFks="}'
    },
    {
      user_id: 1,
      group_id: 3,
      owner: true,
      read_only: false,
      key:
        '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'
    },
    {
      user_id: 1,
      group_id: 4,
      owner: true,
      read_only: false,
      key:
        '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'
    },
    {
      user_id: 2,
      group_id: 1,
      owner: false,
      read_only: true,
      key:
        '{"iv":"+ufs7ck1IVNL2/OGOAO82g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"jQ03irrBvvg=","ct":"ZQgBZSEJaX2d0VVf"}'
    },
    { user_id: 2, group_id: 2, owner: false, read_only: false, key: nil }
  ]

  #"Adam" und "Eva", verschlüsselt mit Key für Klasse 1
  students = [
    {
      name:
        '{"iv":"WCm9XH6cM7s7e3ea4cZB3w==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"nPcGN4uGo9Y=","ct":"MbW6TZm0FKF9pSb1"}',
      gender: 0,
      sen: 0,
      tags: ['Migrationshintergrund'].to_json
    },
    {
      name:
        '{"iv":"6QrHF209McMuDUfcMP3z4g==","v":1,"iter":1000,"ks":128,"ts":64,"mode":"ccm","adata":"","cipher":"aes","salt":"nPcGN4uGo9Y=","ct":"ErP3QkJVO3qUbp0="}'
    }
  ]

  areas = [
    { name: 'Deutsch', color: 'red' },
    { name: 'Mathematik', color: 'blue' },
    { name: 'Verhalten', color: 'black' }
  ]

  competences = [
    [
      { name: 'Leseflüssigkeit', description: 'Tests zur Leseflüssigkeit' },
      { name: 'Rechtschreibung', description: 'Tests zur Rechtschreibung' }
    ],
    [{ name: 'Zahlenstrahl', description: 'Tests zur Arbeit mit dem Zahlenstrahl' }],
    []
  ]

  families = [
    [
      [
        { name: 'Test 1', description: 'Silbenlesen' },
        { name: 'Test 2', description: 'Wortlesen' }
      ],
      []
    ],
    [[]],
    [[]]
  ]

  results = [
    {
      views: {
        'V1': 0.5,
        'V2': {
          'K': 0.66,
          'V': 0.33
        }
      },
      report: {
        'trend': 0,
        'negative': %w[I2 I3 I6],
        'positive': %w[I1 I4 I5]
      },
      data: [
        { item: 'I1', result: 1 },
        { item: 'I2', result: 0 },
        { item: 'I3', result: 0 },
        { item: 'I4', result: 1 },
        { item: 'I5', result: 1 },
        { item: 'I6', result: 0 }
      ]
    },
    {
      views: {
        'V1': 0.5,
        'V2': {
          'K': 0.66,
          'V': 0.33
        }
      },
      report: {
        'trend': 0,
        'negative': %w[I2 I3 I6],
        'positive': %w[I1 I4 I5]
      },
      data: [
        { item: 'I1', result: 1 },
        { item: 'I2', result: 0 },
        { item: 'I3', result: 0 },
        { item: 'I4', result: 1 },
        { item: 'I5', result: 1 },
        { item: 'I6', result: 0 }
      ]
    },
    {
      views: {
        'V1': 0.5,
        'V2': {
          'K': 1,
          'V': 0
        }
      },
      report: {
        'trend': 0,
        'negative': %w[I2 I3 I6],
        'positive': %w[I1 I4 I5]
      },
      data: [
        { item: 'I1', result: 0 },
        { item: 'I2', result: 0 },
        { item: 'I3', result: 0 },
        { item: 'I4', result: 1 },
        { item: 'I5', result: 1 },
        { item: 'I6', result: 1 }
      ]
    }
  ]

  users.each { |u| User.create(u) }

  groups.each_with_index do |g, i|
    group = Group.create(g)
    if (i == 0)
      students.each_with_index do |s, j|
        x = group.students.create(s)
        if (j == 0)
          x.login = 'TEST'
          x.save
        end
      end
    end
    group.save
  end

  group_shares.each { |c| GroupShare.create(c) }

  areas.each_with_index do |a, i|
    area = Area.create(a)
    competences[i].each_with_index do |c, j|
      competence = area.competences.create(c)
      families[i][j].each_with_index do |f, k|
        family = competence.test_families.create(f)
        family.save
      end
      competence.save
    end
    area.save
  end

  #Spieltest anlegen (später per Upload)
  Test.import('db/example_tests/user_based_test/test.zip', false, false)
  Test.import('db/example_tests/student_based_test/test.zip', false, false)

  #Spielergebnisse anlegen
  a1 = Assessment.create(group_id: 1, test_id: Test.find_by_shorthand('Ex_U_1').id)
  Group
    .find(1)
    .students
    .each do |s|
      7.times do |i|
        if (rand > 0.3)
          v = rand * 3
          k = 6 - v
          r =
            a1.results.build(
              student_id: s.id,
              test_date: DateTime.now - 7 * (7 - i),
              views: {
                'V1': (v + k),
                'V2': {
                  'KT': k,
                  'VT': v,
                  'KG': k,
                  'VG': v
                }
              },
              report: {
                'trend': 0,
                'positive': %w[I1 I2 I3],
                'negative': %w[I4 I5 I6]
              },
              data: [
                { 'item': 'I1', 'result': 0 },
                { 'item': 'I2', 'result': 0 },
                { 'item': 'I3', 'result': 0 },
                { 'item': 'I4', 'result': 1 },
                { 'item': 'I5', 'result': 1 },
                { 'item': 'I6', 'result': 1 }
              ]
            )
          r.save
        end
      end
    end

  a2 = Assessment.create(group_id: 1, test_id: Test.find_by_shorthand('Ex_S_1').id)
  s = Student.find(1)
  i = 1
  results.each do |r|
    a2.results.create(
      student_id: s.id,
      test_date: DateTime.now - results.size * 7 + 7 * i,
      views: r[:views],
      report: r[:report],
      data: r[:data]
    )
    i = i + 1
  end

  AnnotationCategory.create(name: 'Test')

  Annotation.create(
    annotation_category_id: 1,
    assessment_id: a1.id,
    end: Student.find(1).results.where(assessment_id: a1.id).order(:test_week).last.test_week,
    group_id: 1,
    start: Student.find(1).results.where(assessment_id: a1.id).order(:test_week).first.test_week,
    view: 0
  )
  Annotation.create(
    annotation_category_id: 1,
    assessment_id: a1.id,
    end: Student.find(1).results.where(assessment_id: a1.id).order(:test_week).first.test_week,
    start: Student.find(1).results.where(assessment_id: a1.id).order(:test_week).first.test_week,
    student_id: 1,
    view: 1
  )

  #Fördermaterial anlegen
  Material.import('db/example_material/cats_and_birds/training.zip', false)

  #Test durch neue Version ersetzen
  Test.import('db/example_tests/student_based_test/test.zip', true, true)
elsif Rails.env.production?
  #Admin Account erzeugen
  STDOUT.puts 'Enter e-mail for admin:'
  email = STDIN.gets.strip.downcase
  STDOUT.puts 'Enter password for admin:'
  pw = STDIN.gets.strip
  STDOUT.puts 'Re-enter password for admin:'
  pwc = STDIN.gets.strip

  u =
    User.create(
      email: email,
      password: pw,
      password_confirmation: pwc,
      capabilities: 'admin',
      state: 15,
      account_type: 1
    )
  if u.save
    STDOUT.puts 'Admin account created!'
  else
    STDOUT.puts 'Something went wrong!'
  end
end

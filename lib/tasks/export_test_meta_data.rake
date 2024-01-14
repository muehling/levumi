require 'csv'
desc 'Export all tests with their meta data'
task 'export_tests_meta_data' => :environment do |_, args|
  tests =
    Test
      .where(archive: false)
      .sort_by do |t|
        [
          t.test_family.competence.area.id,
          t.test_family.competence.id,
          t.test_family.id,
          t.shorthand,
          t.version
        ]
      end
  export = ''
  index = 1
  tests.each do |test|
    tf = TestFamily.find(test.test_family_id)
    c = Competence.find(tf.competence_id)
    a = Area.find(c.area_id)
    tt = test.test_type_id.nil? ? TestType.first.name : TestType.find(test.test_type_id).name
    export <<
      [
        index,
        test.id,
        test.shorthand,
        a.name,
        c.name,
        tf.name,
        test.level,
        test.version,
        test.updated_at.strftime('%d.%m.%Y'),
        test.student_test ? 'Schüler:innen' : 'Lehrkräfte',
        tt
      ].join(',') + "\n"
    index = index + 1
  end
  export = File.open('tests.csv', 'w') { |file| file.write(export) }

  puts 'Done.'
end

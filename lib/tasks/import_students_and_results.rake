desc 'Import students and results from CSV into the database'
task import_students_and_results: :environment do |_, args|
  user_login = 'admin@admin.de'
  test_shorthand = 'ARTH'

  user = User.find_by_email(user_login)
  test = Test.where(shorthand: test_shorthand, archive: false).first

  group_shares = GroupShare.where(user_id: user.id, owner: true).pluck(:group_id)

  group = Group.where(id: group_shares, demo: false, archive: false).first

  puts "Importing in #{group.label}..."

  assessment =
    Assessment.find_or_create_by(
      group_id: group['id'],
      test_id: Test.find_by_shorthand(test_shorthand).id
    )

  student_data = File.read('students.csv')
  student_ids = []
  CSV.parse(student_data, headers: false) do |row|
    student = Student.create!(name: row[1], login: row[0], group_id: group[:id])
    student_ids.push student.id
    puts "Created #{student.login} with id #{student['id']}"
  end

  results_data = File.read('results.csv')

  rows = []

  CSV.parse(results_data, headers: false) { |row| rows.push(row) }

  old_student_ids = rows.map { |row| row[0] }.uniq

  rows.each do |row|
    id_index = old_student_ids.index row[0]
    student = Student.find(student_ids[id_index])
    puts '############################'
    puts row[4]
    puts JSON.parse(row[4])

    result = student.results.build(assessment_id: assessment[:id])
    result.views = JSON.parse('"' + row[3] + '"')
    result.report = JSON.parse('"' + row[4] + '"')
    result.data = JSON.parse('"' + row[5] + '"')
    result.test_date = row[1]
    result.test_week = row[2]

    # result.save

    # Result.create!(
    #   student_id: student_ids[id_index],
    #   test_date: row[1],
    #   test_week: row[2],
    #   views: row[3],
    #   report: row[4],
    #   data: row[5],
    #   assessment_id: assessment[:id]
    # )
    puts "Created result for #{result.student_id}"
  end
  puts 'Done.'
end

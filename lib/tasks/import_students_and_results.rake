desc 'Import students and results from CSV into the database'
task import_students_and_results: :environment do |_, args|
  user_login = 'jbe@informatik.uni-kiel.de'
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

  raw_student_data = File.read('students.json')
  student_data = JSON.parse(raw_student_data)
  student_ids = []
  student_data.each do |data|
    student = Student.create!(name: data['name'], login: data['login'], group_id: group.id)
    student_ids.push(student.id)
  end

  raw_results_data = File.read('results.json')

  results_data = JSON.parse(raw_results_data)
  old_student_ids = results_data.map { |s| s['student_id'] }.uniq
  results_data.each do |result|
    id_index = old_student_ids.index result['student_id']
    result['student_id'] = student_ids[id_index]
    result['assessment_id'] = assessment.id
    Result.create!(result)
  end

  puts 'Done.'
end

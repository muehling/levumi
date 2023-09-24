require 'csv'
desc 'Export all students and results for the passed group.'
task 'export_students_and_results', [:group_id] => :environment do |_, args|
  group = Group.find(args[:group_id])
  students = group.students.includes(:results)
  puts "Group: #{group.label}, student count: #{students.count}"

  File.open('students.json', 'w') { |file| file.write(students.to_json) }

  student_ids = students.pluck(:id)

  results = Result.where(student_id: student_ids)
  File.open('results.json', 'w') { |file| file.write(results.to_json) }

  puts 'Done.'
end

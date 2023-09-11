require 'csv'
desc 'Export all students and results for the passed group.'
task 'export_students_and_results', [:group_id] => :environment do |_, args|
  group = Group.find(args[:group_id])
  students = group.students.includes(:results)
  puts "Group: #{group.label}, student count: #{students.count}"
  student_data =
    CSV.generate(headers: false) do |csv|
      students.each do |student|
        puts student.login
        csv << [student.login, student.name]
      end
    end
  File.write('students.csv', student_data)

  results_data =
    CSV.generate(headers: false) do |csv|
      students.each do |student|
        puts student.results.count
        student.results.each do |r|
          csv << [
            r.student_id,
            r.test_date,
            r.test_week,
            r.views.to_s.tr('\\"', "'"),
            r.report.to_s.tr('\\"', "'"),
            r.data.to_s.tr('\\"', "'")
          ]
        end
      end
    end
  File.write('results.csv', results_data)
  puts 'Done.'
end

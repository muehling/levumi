desc 'Restores results from shadow results. Only works for results where the test/groups/students still exist. Assessments will be created, if necessary.'
task 'restore_results' => :environment do
  group_id = 12_890

  shadows = ShadowResult.where(group: group_id)
  puts "Processing #{shadows.count} records..."
  shadows.each do |shadow|
    test = Test.where(shorthand: shadow.shorthand, archive: false).first
    shadow_student = ShadowStudent.find(shadow.shadow_student_id)
    assessment = Assessment.find_or_create_by(group_id: shadow.group, test_id: test.id)
    Result.create(
      student_id: shadow_student.original_id,
      assessment_id: assessment.id,
      test_date: shadow.test_date,
      test_week: shadow.test_week,
      views: shadow.views,
      report: shadow.report,
      data: shadow.data
    )
  end
end

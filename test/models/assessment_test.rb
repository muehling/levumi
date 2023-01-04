require 'test_helper'

class AssessmentTest < ActionDispatch::IntegrationTest
  test 'Assessment.include/exclude' do
    assessment = assessments(:a1)
    assert_equal assessment.excludes.length, 0
    assessment.exclude 1
    assert_equal assessment.excludes.length, 1
    assert assessment.excludes.include? 1
    assessment.include 1
    refute assessment.excludes.include? 1
  end

  test 'Assessment.get_data' do
    assessment = assessments(:a1)
    data = assessment.get_data

    assert data['student_test'] == false
    assert data['series'].length == 3
  end
end

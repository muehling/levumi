desc "Add or re-add mock-results for a certain group on the box plot test."
task 'seed_bplot_mock' => :environment do
  # group id found in core_data
  g_id = 3

  # first check whether assessments on these tests, for this group, already exist and delete them
  a = Assessment.where(group_id: g_id, test_id: Test.find_by_shorthand('DigiLev-InVo-PT3').id)
  a.each do |assessment|
    assessment.destroy
  end

  # define the parts that won't change for any of the results
  # these won't really matter for the evaluation, as they only show up on "Messungen->Details"
  # that's why we leave them the same
  rep = {
    "trend": 0,
    "negative": ["InVo_Text_S3_N2_A3d", "InVo_Text_S3_N1_A3d", "InVo_Text_S3_N3_A3a"],
    "positive": ["InVo_Id_S2_N1_A7g", "InVo_Id_S2_N2_A5c", "InVo_Id_S1_N3_A5a", "InVo_Id_S3_N1_A8c"]
  }

  # list of IDs of affected students:
  s_ids = Group.find(g_id).students.map{ |s| s.id }.sort

  # define the sequence of correctness results per student
  # info: instruction starts at 3rd point, instruction change is at 6th point
  corr_rows = [
    [0.20, 0.28, 0.19, 0.43, 0.35, 0.57, 0.63, 0.59, 0.67],
    [0.14, 0.21, 0.41, 0.24, 0.17, 0.49, 0.58, 0.74, 0.71],
    [0.21, 0.16, 0.17, 0.29, 0.23, 0.52, 0.57, 0.55, 0.60],
    [0.23, 0.25, 0.20, 0.29, 0.23, 0.55, 0.63, 0.69, 0.70],
    [0.11, 0.19, 0.22, 0.29, 0.23, 0.27, 0.36, 0.40, 0.55],
    [0.10, 0.02, 0.13, 0.19, 0.25, 0.37, 0.46, 0.42, 0.53],
    [0.13, 0.35, 0.22, 0.29, 0.23, 0.37, 0.42, 0.56, 0.63],
    [0.18, 0.07, 0.10, 0.29, 0.15, 0.37, 0.40, 0.48, 0.53],
    [0.16, 0.18, 0.19, 0.29, 0.23, 0.57, 0.51, 0.55, 0.68],
    [0.12, 0.25, 0.29, 0.27, 0.23, 0.28, 0.44, 0.46, 0.55]
  ]
  # define the sequence of correctness results per task type and then student
  # info: instruction starts at 3rd point, instruction change is at 6th point
  box_plot_rows = [
    [{'Text': 0.19, 'Identifizieren': 0.39}, {'Text': 0.43, 'Identifizieren': 0.43}, {'Text': 0.35, 'Identifizieren': 0.55}],
    [{'Text': 0.58, 'Identifizieren': 0.58}, {'Text': 0.74, 'Identifizieren': 0.74}, {'Text': 0.71, 'Identifizieren': 0.81}],
    [{'Text': 0.57, 'Identifizieren': 0.57}, {'Text': 0.55, 'Identifizieren': 0.55}, {'Text': 0.60, 'Identifizieren': 0.66}],
    [{'Text': 0.63, 'Identifizieren': 0.63}, {'Text': 0.69, 'Identifizieren': 0.69}, {'Text': 0.70, 'Identifizieren': 0.74}],
    [{'Text': 0.27, 'Identifizieren': 0.27}, {'Text': 0.36, 'Identifizieren': 0.36}, {'Text': 0.40, 'Identifizieren': 0.45}],
    [{'Text': 0.46, 'Identifizieren': 0.46}, {'Text': 0.42, 'Identifizieren': 0.42}, {'Text': 0.53, 'Identifizieren': 0.80}],
    [{'Text': 0.42, 'Identifizieren': 0.42}, {'Text': 0.56, 'Identifizieren': 0.56}, {'Text': 0.63, 'Identifizieren': 0.68}],
    [{'Text': 0.40, 'Identifizieren': 0.40}, {'Text': 0.48, 'Identifizieren': 0.48}, {'Text': 0.53, 'Identifizieren': 0.69}],
    [{'Text': 0.51, 'Identifizieren': 0.51}, {'Text': 0.55, 'Identifizieren': 0.55}, {'Text': 0.68, 'Identifizieren': 0.60}],
    [{'Text': 0.44, 'Identifizieren': 0.44}, {'Text': 0.46, 'Identifizieren': 0.46}, {'Text': 0.55, 'Identifizieren': 0.75}],
  ]
  # the date when the latest result was measured
  end_date = DateTime.new(2023,3,30)

  # for each test add the same student sequences of results
  # create the assessment that we want to fill
  a = Assessment.create(group_id: g_id, test_id: Test.find_by_shorthand('DigiLev-InVo-PT3').id)
  # go through all students
  for j in 0..8 do
    s = Student.find(s_ids[j])
    c_row = corr_rows[j].reverse # reverse because we go from last to first result
    b_row = box_plot_rows[j].reverse
    # and per student go through all their results
    for k in 0..8 do
      a.results.create(
        student_id: s.id,
        test_date: end_date - 7 * k,
        views: {
          'correctness': c_row[k],
          'exerciseTypeBoxPlots': b_row[0]
        },
        report: rep,
        data: []
      )
    end
  end

end

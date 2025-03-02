desc 'Importing the Backup data.'
task 'import_backup' => :environment do |_, args|
  puts 'test'
  puts 'Please enter the mailadress of the user:'

  #awaiting input
  user_login = STDIN.gets.chomp

  #getting user
  user = User.find_by_email(user_login)
  user_id = user.id

  #prepare the user_login mail for filename
  filename = user_login.gsub('@', 'at')

  raw_import_data = File.read('./recovery_' + filename + '.json')
  backup_data = JSON.parse(raw_import_data)

  user_data = backup_data['user']
  group_shares_data = backup_data['group_shares']
  results_data = backup_data['results']
  assessments_data = backup_data['assessments']
  students_data = backup_data['students']
  tests_data = backup_data['tests']
  groups_data = backup_data['groups']

  #############################################
  #test if user id is not overwritten yet
  #############################################
  user = User.find_by_email(user_login)
  unless user.id == user_data['id']
    #user.id is overwritten => create new User and change the old id to the new one
    new_user =
      User.create(
        email: user_data['email'],
        password_digest: user_data['password_digest'],
        security_digest: user_data['security_digest'],
        account_type: user_data['account_type'],
        capabilities: user_data['capabilities'],
        last_login: last_login['last_login'],
        state: user_data['state'],
        institution: user_data['institution'],
        town: user_data['town'],
        school_type: user_data['school_type'],
        focus: user_data['focus'],
        tc_accepted: user_data['tc_accepted'],
        intro_state: last_login['intro_state'],
        settings: user_data['settings']
      )

    #updateing old user.id refrences
    group_shares.each { |group| group['user_id'] = new_user.id }
  end

  ###########################################
  #overwrite group_ids
  ###########################################
  groups_data.each do |group|
    #forming new group_ids
    new_group =
      Group.create(
        label: group['label'],
        archive: group['archive'],
        demo: group['demo'],
        auth_token: group['auth_token']
      )
    old_id = group['id']

    #updating old group.id refrences
    group_shares_data.each do |shared|
      shared['group_id'] = new_group.id if shared['group_id'] == old_id
    end
    students_data.each do |student|
      student['group_id'] = new_group.id if student['groupd_id'] == old_id
    end
    assessments_data.each do |assessment|
      assessment['group_id'] = new_group.id if assessment['groupd_id'] == old_id
    end
  end

  ##########################################
  #overwrite group_share_ids
  ##########################################
  group_shares_data.each do |shared|
    #forming new group_shares
    new_group_share =
      GroupShare.create(
        owner: shared['owner'],
        read_only: shared['read_only'],
        key: shared['key'],
        user_id: shared['user_id'],
        group_id: shared['group_id'],
        is_anonymous: shared['is_anonymous']
      )
  end

  ##########################################
  #updating test_ids
  ##########################################
  tests_data.each do |test|
    active_test = Test.find_by_shorthand(test['shorthand'])
    raise 'no Test like this' if active_test.nil?
    if active_test.id != test['id']
      #updating old refrences
      assessments_data.each do |ass|
        ass['test_id'] = active_test.id if ass['test_id'] == test['id']
      end
      test['id'] = active_test.id
    end
  end

  ##########################################
  #overwrite assessments
  ##########################################
  assessments_data.each do |ass|
    new_assessment =
      Assessment.create(
        group_id: ass['group_id'],
        test_id: ass['test_id'],
        active: ass['active'],
        excludes: ass['excludes']
      )

    #updating old assessment_id references
    results_data.each do |result|
      result['assessment_id'] = new_assessment.id if result['assessment_id'] == ass['id']
    end
  end

  ##########################################
  #overwrite students
  ##########################################
  students_data.each do |student|
    new_student =
      Student.create(
        name: student['name'],
        login: student['login'],
        group_id: student['group_id'],
        gender: student['gender'],
        birthmonth: student['birthmonth'],
        sen: student['sen'],
        tags: student['tags'].to_s
      )

    #updating old student_id refrences
    results_data.each do |result|
      result['assessment_id'] = new_student.id if result['assessment_id'] == student['id']
    end
  end

  ##########################################
  #overwrite results
  ##########################################
  results_data.each do |result|
    new_result =
      Result.create(
        student_id: result['student_id'],
        assessment_id: result['assessment_id'],
        test_date: result['test_date'],
        test_week: result['test_week'],
        views: result['views'],
        report: result['report'],
        data: result['data']
      )
  end
  puts 'Done'
end

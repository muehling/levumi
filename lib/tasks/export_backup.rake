desc 'Recover deleted Assessments of an user'
task 'export_backup' => :environment do |_, args|
  puts 'test'
  puts 'Please enter the mailadress of the user:'

  #awaiting input
  user_login = STDIN.gets.chomp

  #getting user
  user = User.find_by_email(user_login)
  user_id = user.id

  #Active Record Object of User
  group_shares = GroupShare.where(user_id: user_id)

  #prepare the user_login mail for filename
  user_login = user_login.gsub('@', 'at')

  group_share_ids = group_shares.pluck(:id)

  #groups = Group.where(id: group_share_ids)

  results = []
  assessments = []
  students = []
  tests = []
  groups = []

  #filling arrays
  group_shares.each do |group_share|
    students = students + Student.where(group_id: group_share.id)
    assessments = assessments + Assessment.where(group_id: group_share.id)
    assessment_ids = assessments.pluck(:id)
    results = results + Result.where(id: assessment_ids)
    groups = groups + Group.where(id: group_share.group_id)
  end

  assessments.each do |assessment|
    a = assessment.test_id
    t = Test.find(a)
    helper = { id: a, shorthand: t.shorthand }
    tests.push(helper)
  end

  #building object to export
  export = {
    user: user,
    group_shares: group_shares,
    results: results,
    assessments: assessments,
    students: students,
    tests: tests,
    groups: groups
  }
  export = File.open('recovery_' + user_login + '.json', 'w') { |file| file.write(export.to_json) }

  puts 'Done.'
end

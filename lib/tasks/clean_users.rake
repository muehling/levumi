desc 'Remove users that registered but never became active in the platform.'
task 'clean_users' => :environment do
  puts "Current number of users: #{User.all.count}"
  todo = User.where(intro_state: 1).where('created_at < ?', 3.weeks.ago).all
  size = todo.count
  todo.destroy_all
  puts "Removed #{size} users, #{User.all.count} left"
end

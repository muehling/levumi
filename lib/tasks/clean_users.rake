desc "Remove users that registered but never became active in the platform."
task 'clean_users' => :environment do
  todo = User.where(tc_accepted: nil).where("created_at < ?", 3.weeks.ago).all
  todo.each do |t|
    puts t.email
    t.destroy
  end
  puts "Removed #{todo.size} users"
end

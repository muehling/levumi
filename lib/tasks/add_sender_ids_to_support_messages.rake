desc 'Adds the id of the sending user to support messages'
task 'add_sender_id' => :environment do
  todo = SupportMessage.all
  todo.each do |sm|
    u = User.find_by_email(sm.sender)
    puts sm[:sender]
    sm.update(user_id: u.id) if !u.nil?
  end
end

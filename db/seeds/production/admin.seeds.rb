# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

STDOUT.puts "Enter e-mail for admin:"
email = STDIN.gets.strip.downcase
STDOUT.puts "Enter password for admin:"
pw = STDIN.gets.strip
STDOUT.puts "Re-enter password for admin:"
pwc = STDIN.gets.strip

u = User.create(email: email, password: pw, password_confirmation: pwc, name: "Administrator", capabilities:"admin", state:15, account_type: 2)
if u.save
  STDOUT.puts "Admin account created!"
else
  STDOUT.puts "Something went wrong!"
end


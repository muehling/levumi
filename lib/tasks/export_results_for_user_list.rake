require 'zip'

desc 'Exports all ARTH_SHORT results for the given users list'
task export_arth_short_results: :environment do
  users_file = File.open('users.txt', 'r')
  file_name = "ARTH_SHORT_export_#{DateTime.now.strftime('%Y_%m_%d')}.zip"
  File.delete(file_name) if File.exists?(file_name)
  users_file.each_line do |line|
    user_email = line.strip.to_s

    user = User.find_by_email(user_email)
    if user
      zip_data = user.as_zip(['ARTH_SHORT'])

      Zip::File.open(file_name, Zip::File::CREATE) do |zipfile|
        zipfile.add("#{user.email.parameterize.underscore}.zip", zip_data)
      end
      puts "Created export for #{user.email}"
    else
      puts "User #{user_email} not found"
    end
  end
  users_file.close
end

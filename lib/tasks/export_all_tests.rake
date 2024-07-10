require 'zip'

desc 'Exports all tests; can be used instead of pressing all export buttons in the export list'
task export_all_tests: :environment do
  file_name = "export_all_tests_#{DateTime.now.strftime('%Y_%m_%d')}.zip"
  File.delete(file_name) if File.exists?(file_name)
  count = Test.all.count
  Test.all.each_with_index do |t, i|
    puts "(#{i}/#{count}) Exporting #{t.shorthand...}"

    t.as_csv_file
    puts '... done.'
  end
end

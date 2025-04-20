desc 'Update quartile data for each test. Intended to be run monthly by cron.'
task 'update_quartiles' => :environment do
  Rails.cache.delete_matched('*_quartiles')

  Test.all.each do |test|
    puts "Updating #{test.shorthand}/#{test.version}..."
    test.update_quartiles
  end
end

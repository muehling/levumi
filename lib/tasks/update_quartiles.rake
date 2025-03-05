desc 'Update quartile data for each test. Intended to be run weekly by cron.'
task 'update_quartiles' => :environment do
  Test.all.each do |test|
    puts "Updating #{test.shorthand}/#{test.version}..."
    test.update_quartiles
  end
end

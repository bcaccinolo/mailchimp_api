task :default do
  puts "default task"
end

desc "Launch unit tests."
task :test do 
  require 'test/unit/ui/console/testrunner'
  require 'test/test_mc'
  Test::Unit::UI::Console::TestRunner.run(TestMailChimp)
end



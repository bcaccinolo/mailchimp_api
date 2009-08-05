

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "Mailchimp_api"
    gemspec.summary = "Summarize your gem"
    gemspec.description = "Describe your gem"
    gemspec.email = "josh@technicalpickles.com"
    gemspec.homepage = "http://github.com/technicalpickles/the-perfect-gem"
    gemspec.description = "TODO"
    gemspec.authors = ["Josh Nichols"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end




task :default do
  puts "default task"
end

desc "Launch unit tests."
task :test do 
  require 'test/unit/ui/console/testrunner'
  require 'test/test_mc'
  Test::Unit::UI::Console::TestRunner.run(TestMailChimp)
end




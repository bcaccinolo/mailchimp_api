

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "mailchimp_api"
    gemspec.summary = "Summarize your gem"
    gemspec.description = "Describe your gem"
    gemspec.email = "benoit.caccinolo@gmail.com"
    gemspec.homepage = "http://ruready.tumblr.com"
    gemspec.description = "TODO"
    gemspec.authors = ["Benoit Caccinolo"]
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




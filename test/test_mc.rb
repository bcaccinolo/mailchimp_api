require "test/unit"

class TestMailChimp < Test::Unit::TestCase

  def setup
    puts "setup method"
  end

  def teardown
    puts "teardown method"
  end

  def test_one
    assert(false, "it is false")
  end


  def test_two
    assert(true, "it is true")
  end

end

require 'test/unit/ui/console/testrunner'
Test::Unit::UI::Console::TestRunner.run(TestMailChimp)




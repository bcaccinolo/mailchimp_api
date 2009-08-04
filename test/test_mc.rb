require "test/unit"
require "lib/mailchimp"

class TestMailChimp < Test::Unit::TestCase

  def setup
    if @done.nil?
      @done = true
      @mc = MailChimp.new
      @mc.login 'bcaccinolo', 'aden'
      test_lists
    end
  end

  #def teardown
  #end

  def test_ping
    ret = @mc.ping
    assert ret == true
  end
  
  def test_lists
    ret = @mc.lists
    list_ids = ret.map { |e| e['name'] }
    result = list_ids.include?("test_list")
    unless result 
      raise "In order to continue the tests, you have to create a list called test_list."
    end
    @list_id= ""
    ret.each do |list| 
      @list_id = list["id"] if list["name"] == "test_list"
    end
    assert result
  end

  def test_list_subscribe
    puts @mc.list_subscribe @list_id, "benoit@gmail.com"
  end

end


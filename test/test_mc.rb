require "test/unit"
require "lib/mailchimp_api"

LOGIN=""
PWD=""

class TestMailChimp < Test::Unit::TestCase

  @@done = nil
  @@list_id = ""
  @@campaign_id = ""

  def setup
    raise "You have to set the Constants LOGIN and PWD." if LOGIN == ""
    if @@done.nil?
      @@done = true
      @@mc = MailChimp.new
      @@mc.login LOGIN, PWD
      test_lists
    end
  end

  #def teardown
  #end

  def test_ping
    ret = @@mc.ping
    assert ret == true
  end
  
  def test_lists
    ret = @@mc.lists
    list_ids = ret.map { |e| e['name'] }
    result = list_ids.include?("test_list")
    unless result 
      raise "In order to continue the tests, you have to create a list called test_list."
    end
    ret.each do |list| 
      @@list_id = list["id"] if list["name"] == "test_list"
    end
    assert result
  end

  def test_list_subscribe
    assert @@mc.list_subscribe(@@list_id, "benoit_test@gmail.com")
  end

  def test_list_unsubscribe
    assert @@mc.list_unsubscribe(@@list_id, "benoit_test@gmail.com")
  end

  def test_list_batch_subscribe
    ret = @@mc.list_batch_subscribe(@@list_id, [ {"EMAIL" => "benoit_test4@gmail.com"} ]) 
    assert(ret["success_count"] == 1, ret.to_yaml)
  end

  def test_list_batch_unsubscribe
    @@mc.list_subscribe(@@list_id, "benoit_test1@gmail.com")
    @@mc.list_subscribe(@@list_id, "benoit_test2@gmail.com")
    ret = @@mc.list_batch_unsubscribe(@@list_id, ["benoit_test1@gmail.com", "benoit_test2@gmail.com"])
    assert(ret["success_count"] == 2, ret.to_yaml)
  end

  def test_campaign_create_and_delete
    ret = @@mc.campaign_create(@@list_id, "from_benoit@gmail.com", "Benoit Caccinolo", 
                        "This the subject of the newsletter", 
                        "This is the content of the newsletter")
    if ret.class == String
      @@campaign_id = ret
    end
    assert(ret.class == String)

    ret = @@mc.campaign_delete @@campaign_id
    assert ret
  end

  def test_campaign_update
    ret = @@mc.campaign_create(@@list_id, "from_benoit@gmail.com", "Benoit Caccinolo", 
                        "This the subject of the newsletter", 
                        "This is the content of the newsletter")
    campaign_id = ret
    ret = @@mc.campaign_update(campaign_id, "content", {"html" => "New content"})
    assert ret
    @@mc.campaign_delete campaign_id
  end

  def test_campaign_send_test
    ret = @@mc.campaign_create(@@list_id, "from_benoit@gmail.com", "Benoit Caccinolo", 
                        "This the subject of the newsletter 2222222222222", 
                        "This is the content of the newsletter")
    campaign_id = ret

    ret = @@mc.campaign_send_test(campaign_id, ["benoit.caccinolo@gmail.com"])
    assert ret
    ret = @@mc.campaign_delete campaign_id
  end

end


# For the API 1.1
#
require "rubygems"
require 'net/http'
require 'uri'
require "json"
require 'yaml'

class MailChimp

  attr_accessor :api

  def login username, password
    ret = call_server 'login', {:username => username, :password => password}
    @api = ret.slice(1, ret.size-2) if ret.class == String
  end

  def ping
    ret = call_server 'ping'
    return ((ret.class == String) and !(ret =~ /Everything.*Chimpy/).nil?) ? true : false 
  end

  def campaign_create list_id, from_email, from_name, subject, content
    params = {:options => {:list_id => list_id, :subject => subject, 
              :from_name => from_name, :from_email => from_email}, 
              :type => "regular", :content => content}
    ret = call_server 'campaignCreate', params
    puts ret
    if ret.class == String
      ret.slice(1, ret.size-2) 
    else
      nil
    end
  end

  def campaign_update cid, name, value
    params = {:cid => cid, :name => name, :value => value}
    ret = call_server 'campaignUpdate', params
    puts ret 
  end

  def campaign_delete cid
    params = {:cid => cid}
    ret = call_server 'campaignDelete', params
    puts ret 
  end

  def campaign_send_now cid
    params = {:cid => cid}
    ret = call_server 'campaignSendNow', params
    puts ret
  end

  def campaign_send_test cid, emails
    params = {:cid => cid, :test_emails => emails}
    ret = call_server 'campaignSendTest', params
    puts ret
  end

  def list_batch_suscribe list_id, batch_emails
    params = {:id => list_id, :batch => batch_emails}
    ret = call_server 'listBatchSuscribe', params
    puts ret
  end

  def list_batch_unsuscribe list_id, batch_emails
    params = {:id => list_id, :batch => batch_emails, :delete_member => true, :send_goodbye => false }
    ret = call_server 'listBatchUnsuscribe', params
    puts ret
  end

  def list_subscribe list_id, email
    params = {:id => list_id, :email_address => email, 
              :merge_vars => {'FIRST' => '', 'LAST' => ''} , :double_optin => false}
    ret = call_server 'listSubscribe', params
    ret
  end

  def list_unsubscribe list_id, email
    params = {:id => list_id, :email_address => email}
    ret = call_server 'listUnsubscribe', params
    puts ret
  end

  def lists
    params = {}
    ret = call_server 'lists', params
    puts ret
    ret
  end

  def list_members list_id
    params = {:id => list_id}
    ret = call_server 'listMembers', params
    (ret.class == Hash) ? [] : ret
  end

  def call_server method , params={}
    url = "api.mailchimp.com"
    path = "/1.1/?output=json&method=#{method}"
    params[:apikey] = @api unless method == "login"
    data = gen_params_list(params)
    puts "http://#{url}#{path}&#{data}"
    http = Net::HTTP.new(url)
    result = http.post(path, data)
    begin
      json_res = JSON.parse result.body
    rescue JSON::ParserError
      json_res = result.body
    end
    json_res
  end

  def gen_params_list params
    params.map do |key, value|
      if value.class == Hash
        value.map do |k, v| 
         "#{key}[#{k}]=#{v}" 
        end.join '&'
      elsif value.class == Array
        value.map do |v|
         "#{key}[]=#{v}" 
        end.join '&'
      else
        "#{key}=#{value}"
      end 
    end.join '&'
  end

end

#mc = MailChimp.new
#mc.login 'bcaccinolo', 'aden'
#puts mc.ping
#mc.lists
#mc.list_members "905f5c89d5"





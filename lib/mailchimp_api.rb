# For the API 1.1
# http://www.mailchimp.com/api/1.1/
#
require "rubygems"
require 'net/http'
require 'uri'
require "json"
require 'yaml'

class MailChimp

  attr_accessor :api

  # tested
  def login username, password
    ret = call_server 'login', {:username => username, :password => password}
    @api = ret.slice(1, ret.size-2) if ret.class == String
  end

  # tested
  def ping
    ret = call_server 'ping'
    return ((ret.class == String) and !(ret =~ /Everything.*Chimpy/).nil?) ? true : false 
  end

  # tested
  def campaign_create list_id, from_email, from_name, subject, content, generate_text = true
    params = {:options => {:list_id => list_id, :subject => subject, 
              :from_name => from_name, :from_email => from_email}, 
              :type => "regular", :content => content, :generate_text => generate_text}
    ret = call_server 'campaignCreate', params
    if ret.class == String
      ret = ret.slice(1, ret.size-2) 
    end
    ret
  end

  # tested
  def campaign_update cid, name, value
    params = {:cid => cid, :name => name, :value => value}
    ret = call_server 'campaignUpdate', params
    ret 
  end

  # tested
  def campaign_delete cid
    params = {:cid => cid}
    ret = call_server 'campaignDelete', params
    ret 
  end

  # not tested
  def campaign_send_now cid
    params = {:cid => cid}
    ret = call_server 'campaignSendNow', params
    ret
  end

  # tested
  def campaign_send_test cid, emails
    params = {:cid => cid, :test_emails => emails}
    ret = call_server 'campaignSendTest', params
    ret
  end

  # not tested
  def list_batch_subscribe list_id, batch_emails
    params = {:id => list_id, :batch => batch_emails}
    ret = call_server 'listBatchSubscribe', params
    ret
  end

  # tested
  def list_batch_unsubscribe list_id, batch_emails
    params = {:id => list_id, :emails => batch_emails, :delete_member => true, :send_goodbye => false }
    ret = call_server 'listBatchUnsubscribe', params
    ret
  end

  # tested
  def list_subscribe list_id, email
    params = {:id => list_id, :email_address => email, 
              :merge_vars => {'FIRST' => '', 'LAST' => ''} , :double_optin => false}
    ret = call_server 'listSubscribe', params
    ret
  end

  # tested
  def list_unsubscribe list_id, email
    params = {:id => list_id, :email_address => email}
    ret = call_server 'listUnsubscribe', params
    ret
  end

  # tested
  def lists
    params = {}
    ret = call_server 'lists', params
    ret
  end

  # not tested
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
    #puts ">>> http://#{url}#{path}&#{data}"
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
         "#{key}[#{k}]=#{CGI::escape(v.to_s)}" 
        end.join '&'
      elsif value.class == Array
        value.map do |v|
         "#{key}[]=#{CGI::escape(vi.to_s)}"
        end.join '&'
      else
        "#{key}=#{CGI::escape(value.to_s)}"
      end 
    end.join '&'
  end

end


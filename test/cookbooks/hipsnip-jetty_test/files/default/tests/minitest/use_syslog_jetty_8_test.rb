require File.expand_path('../support/helpers', __FILE__)
require 'net/http'

describe_recipe "hipsnip-jetty_use_syslog_jetty_8_test::default" do
  include Helpers::CookbookTest

  before do
    uri = URI("http://127.0.0.1:#{node['jetty']['port']}")
    attempts_total = 3;
    attempts_remaining = attempts_total
    wait_between_attempt = 10
    while attempts_remaining != 0
      begin
        if attempts_remaining != attempts_total
          puts "New attempt in #{wait_between_attempt} seconds..."
          sleep(wait_between_attempt)
        end
        attempts_remaining = attempts_remaining - 1
        response = Net::HTTP.get_response(uri)
        break
      rescue Errno::ECONNREFUSED => econnrefused
        #catch connection error
        puts econnrefused.inspect
        puts "#{attempts_remaining}/#{attempts_total} remaining attempt(s) ..."
      end
    end
  end

  it "should have started a Jetty server" do
    uri = URI("http://127.0.0.1:#{node['jetty']['port']}")
    response = Net::HTTP.get_response(uri)
    # no web app have been provisionned so it is expected to have a HTTP 404 response
    assert_instance_of(Net::HTTPNotFound, response,"HTTP response")
  end
  it "should have written logs into syslog" do
    path = '/var/log/syslog'
    syslog_file_exists = File.exists?(path)
    assert_equal(true,syslog_file_exists)
    File.open(path,'r') do |file|
      content = file.read
      assert_equal(true,!!content.match(/jetty/))
    end
  end
end
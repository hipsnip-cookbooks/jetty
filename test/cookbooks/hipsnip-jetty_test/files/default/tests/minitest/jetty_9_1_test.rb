require File.expand_path('../support/helpers', __FILE__)
require 'net/http'

describe_recipe "hipsnip-jetty_test::jetty_9_1" do
  include Helpers::CookbookTest

  it "should have started a Jetty server" do
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
    # no web app have been provisionned so it is expected to have a HTTP 404 response
    assert_instance_of(Net::HTTPNotFound, response,"HTTP response")
  end
end

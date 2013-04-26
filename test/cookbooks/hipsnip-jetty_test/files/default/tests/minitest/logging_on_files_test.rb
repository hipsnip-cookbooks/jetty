require File.expand_path('../support/helpers', __FILE__)
require 'net/http'

describe_recipe "hipsnip-jetty_logging_on_files_test::default" do
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
  it "should log into /var/log/jetty" do
    log_directory_exist = File.exists?(node['jetty']['logs'])
    assert_equal(true,log_directory_exist,'log directory exists')
    time = Time.now
    date = time.strftime("%Y_%m_%d")
    log_file_stderrout_exist = File.exists?(File.join(node['jetty']['logs'],"#{date}.stderrout.log"))
    assert_equal(true,log_file_stderrout_exist,'log file stderrout exists')
  end
end
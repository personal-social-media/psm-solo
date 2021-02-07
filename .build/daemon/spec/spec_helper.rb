ENV["DAEMON_TEST"] = "TRUE"
require "thor"
Dir["#{File.dirname(__FILE__)}/../daemon/**/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/../../thor/**/*.rb"].each { |file| require file }
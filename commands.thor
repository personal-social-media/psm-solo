# frozen_string_literal: true

require 'total'
require 'etc'
require "erb"
require "securerandom"
ENV["THOR_SILENCE_DEPRECATION"] = "TRUE"
Dir["#{File.dirname(__FILE__)}/.build/thor/**/*.rb"].each { |file| require file }

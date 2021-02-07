# frozen_string_literal: true

require 'total'
require 'etc'
require "erb"
require 'colorize'
require 'fileutils'
require "securerandom"
ENV["THOR_SILENCE_DEPRECATION"] = "TRUE"
Dir["#{File.dirname(__FILE__)}/.build/thor/**/*.rb"].each { |file| require file }

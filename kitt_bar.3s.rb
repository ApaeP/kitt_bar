#!/usr/bin/env ruby

# <xbar.title>Kitt Bar</xbar.title>
# <xbar.version>v1.1</xbar.version>
# <xbar.author>Paul P, Paul L</xbar.author>
# <xbar.author>@ApaeP, @paultursuru</xbar.author>
# <xbar.desc>Kitt Plugin</xbar.desc>
# <xbar.image>https://kitt.lewagon.com/slack/slack-bot-logo.png</xbar.image>
# <xbar.dependencies>Ruby</xbar.dependencies>
# require 'bundler/inline'

# gemfile do
#   source 'https://rubygems.org'
#   gem 'pry-byebug'
#   gem 'sqlite3'
# end

begin
  require 'sqlite3'
  require 'fileutils'
  require 'open3'
  require 'json'


  require_relative 'kitt_bar_app/config/setup'

  batches_json_file = File.join(__dir__, "kitt_bar_app/config/batches.json")
  batches_serialized = File.read(batches_json_file)
  batches            = JSON.parse(batches_serialized)

  CURRENT_BATCHES    = batches.dig('current_batches').map{|batch| batch.transform_keys(&:to_sym)}
  OLD_BATCHES        = batches.dig('old_batches').map{|batch| batch.transform_keys(&:to_sym)}
  KITT_COOKIE        = SessionCookie.firefox

  require_relative 'kitt_bar_app/plugin'

  Plugin.run(CURRENT_BATCHES, OLD_BATCHES)
rescue => error
  # binding.pry
  puts "KittBar Error"
  puts "---"
  puts "Error:"
  puts "---"
  puts error.full_message
  puts "---"
  puts error.message
  puts error.backtrace
  puts "---"
  puts "Please fill the batches.json file with your batches :)"
  puts "here should be some documentation about how to do so|href=https://github.com/ApaeP/kitt_bar#2---setup-your-batches"
end

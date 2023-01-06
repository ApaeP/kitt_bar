#!/usr/bin/env ruby

# <bitbar.title>Kitt Bar</bitbar.title>
# <bitbar.version>v1.1</bitbar.version>
# <bitbar.author>Sébastien Saunier (extended by Paul Portier)</bitbar.author>
# <bitbar.author.github>ssaunier (extended by @ApaeP)</bitbar.author.github>
# <bitbar.desc>Kitt Bar (Le Wagon)</bitbar.desc>
# <bitbar.image>https://kitt.lewagon.com/slack/slack-bot-logo.png</bitbar.image>
# <bitbar.dependencies>Ruby</bitbar.dependencies>

require "json"

batches_serialized = File.read('kitt_bar_app/assets/batches.json')
batches = JSON.parse(batches_serialized)
CURRENT_BATCHES = batches.dig('current_batches').map{|batch| batch.transform_keys(&:to_sym)}
OLD_BATCHES = batches.dig('old_batches').map{|batch| batch.transform_keys(&:to_sym)}

File.read('.env').split("\n").each do |env_var|
  eval env_var
end

KITT_COOKIE = KITT_USER_COOKIE

require_relative 'kitt_bar_app/config/setup'
require_relative 'kitt_bar_app/plugin'

Plugin.run(CURRENT_BATCHES, OLD_BATCHES)

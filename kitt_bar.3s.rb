#!/usr/bin/env /Users/paulportier/.rbenv/shims/ruby

# <bitbar.title>Kitt Bar</bitbar.title>
# <bitbar.version>v1.1</bitbar.version>
# <bitbar.author>Sébastien Saunier (extended by Paul Portier)</bitbar.author>
# <bitbar.author.github>ssaunier (extended by @ApaeP)</bitbar.author.github>
# <bitbar.desc>Kitt Bar (Le Wagon)</bitbar.desc>
# <bitbar.image>https://kitt.lewagon.com/slack/slack-bot-logo.png</bitbar.image>
# <bitbar.dependencies>Ruby</bitbar.dependencies>

File.read('.env').split("\n").each do |env_var|
  eval env_var
end

BATCH_INFOS = [
  { slug: 1116, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 984, type: 'FT', cursus: 'Web', city: 'Paris'}
]

OLD_BATCHES = [
  { slug: 1030, type: 'FT', cursus: 'Web', city: 'Paris'}
]

KITT_COOKIE = KITT_USER_COOKIE

require_relative 'kitt_bar_app/config/setup'
require_relative 'kitt_bar_app/plugin'

Plugin.run(BATCH_INFOS, OLD_BATCHES)

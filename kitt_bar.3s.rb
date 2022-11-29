#!/usr/bin/env ruby

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
  { slug: 1030, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 1003, type: 'PT', cursus: 'Web', city: 'Paris'},
]

OLD_BATCHES = [
  { slug: 940, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 860, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 810, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 801, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 730, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 724, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 703, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 660, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 636, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 590, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 554, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 550, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 500, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 440, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 422, type: 'PT', cursus: 'Web', city: 'Paris'},
  { slug: 400, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 350, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 320, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 886, type: 'FT', cursus: 'Web', city: 'Remote'},
  { slug: 1080, type: 'FT', cursus: 'Data Analytics', city: 'Paris'},
  { slug: 993, type: 'FT', cursus: 'Web', city: 'Martinique'},
  { slug: 827, type: 'FT', cursus: 'Web', city: 'Martinique'},
  { slug: 762, type: 'FT', cursus: 'Web', city: 'Martinique'},
]

KITT_COOKIE = KITT_USER_COOKIE

require_relative 'kitt_bar_app/config/setup'
require_relative 'kitt_bar_app/plugin'

Plugin.run(BATCH_INFOS, OLD_BATCHES)

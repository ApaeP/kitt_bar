#!/usr/bin/env ruby

# <xbar.title>Kitt Bar</xbar.title>
# <xbar.version>v1.1</xbar.version>
# <xbar.author>Paul P, Paul L</xbar.author>
# <xbar.author>@ApaeP, @paultursuru</xbar.author>
# <xbar.desc>Kitt Plugin</xbar.desc>
# <xbar.image>https://kitt.lewagon.com/slack/slack-bot-logo.png</xbar.image>
# <xbar.dependencies>Ruby</xbar.dependencies>

require 'sqlite3'
require 'fileutils'
require 'open3'
require 'json'

require_relative 'kitt_bar_app/config/setup'

BATCH_INFOS = [
  { slug: 1116, type: 'FT', cursus: 'Web', city: 'Paris'},
  { slug: 984, type: 'FT', cursus: 'Web', city: 'Paris'}
]

OLD_BATCHES = [
  { slug: 1030, type: 'FT', cursus: 'Web', city: 'Paris'}
]

KITT_COOKIE = SessionCookie.firefox

require_relative 'kitt_bar_app/plugin'

Plugin.run(BATCH_INFOS, OLD_BATCHES)

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

config_serialized  = File.read('kitt_bar_app/config/settings.json')
config             = JSON.parse(config_serialized)

CURRENT_BATCHES    = config.dig('current_batches').map{ |batch| batch.transform_keys(&:to_sym) }
OLD_BATCHES        = config.dig('old_batches').map{ |batch| batch.transform_keys(&:to_sym) }
SKILLS             = config.dig('skills').first.values.flatten.map{ |skill| skill.dig("skill_id") if skill.dig("can_do") }.join(",")
GITHUB_USERNAME    = config.dig('github_username')
KITT_COOKIE        = SessionCookie.firefox

require_relative 'kitt_bar_app/plugin'

Plugin.run(CURRENT_BATCHES, OLD_BATCHES)

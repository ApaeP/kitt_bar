#!/usr/bin/env ruby

# <bitbar.title>Kitt Bar</bitbar.title>
# <bitbar.version>v1.1</bitbar.version>
# <bitbar.author>Sébastien Saunier (extended by Paul Portier)</bitbar.author>
# <bitbar.author.github>ssaunier (extended by @ApaeP)</bitbar.author.github>
# <bitbar.desc>Kitt Bar (Le Wagon)</bitbar.desc>
# <bitbar.image>https://kitt.lewagon.com/slack/slack-bot-logo.png</bitbar.image>
# <bitbar.dependencies>Ruby</bitbar.dependencies>

## CONFIGURATION
def set_cookie_variable_from_env
  eval File.read('.env').split("\n").find { |s| s.start_with?('KITT_USER_COOKIE') }
end

set_cookie_variable_from_env

BATCH_SLUGS = [1030, 1003]
KITT_COOKIE = KITT_USER_COOKIE
ANSI_COLORS = {
  green: "\e[38;5;76m",
  red: "\e[38;5;160m",
  orange: "\e[38;5;214m",
  gray: "\e[38;5;250m",
  darkgray: "\e[38;5;240m",
  lightgray: "\e[38;5;255m",
  white: "\e[38;5;15m",
  reset: "\u001b[0m"
}

require_relative 'kitt_bar_app/plugin'

Plugin.call(BATCH_SLUGS)

# xbardoc
# puts "coloredtext|color=#{plugin.color}"
# puts "Tickets|href=#{plugin.tickets_url}"

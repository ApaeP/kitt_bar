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
require 'base64'
require 'open-uri'

require_relative 'kitt_bar_app/config/setup'

config_serialized   = File.read('kitt_bar_app/config/settings.json')
config              = JSON.parse(config_serialized)

CURRENT_BATCHES     = config.dig('current_batches').map{|batch| batch.transform_keys(&:to_sym)}
OLD_BATCHES         = config.dig('old_batches').map{|batch| batch.transform_keys(&:to_sym)}
SKILLS              = config.dig('skills').first.values.flatten.map{|skill| skill.dig("skill_id") if skill.dig("can_do")}.join(",")
GITHUB_USERNAME     = config.dig('github_username')
KITT_COOKIE         = "_kitt2017_=pZ%2F66e2qnOcCT4Ucg4gsZunxGWKO2q2ZYL56qHmo4%2B%2Fy2RWaJbhcGKqwaactghZ25lV8CNnT8ZdapJ%2BSfnNWJ8aRRINPYVYk742ouK6B%2BelFrGe%2FO4P7qXDV9WsDz6DgFfg1fRLKwsuXHYbbAWdIVV6n9Hdx3bq%2FUJGa6PPdiHpod%2FWx7HbqgyGbe%2FbO0chuXps36ZS823QX8fxOmaTCvbWgvVDhw%2FpwZt84W0WudkJq4TOQ6xSaKqkV1HaJ%2Fze0dZuej9tJtJGp87fVsy9vsHeIeIQF%2BbYcQbuzBhCYKmByGNi7FcJ1YjF0%2FLFEVPyQwm%2B7N8AWFdsEazDMDFXAWuJSCGyz2nHn6YOIf4aP5O1%2FDgL%2FFaQRnXg6kJzwhj25K7BdvZqB98H8Sf%2BJYBXUUlSu7oTPgNIDauI6XN4S0QqREUiDQPHpfdIG0h81%2BQH%2F4ZeXqGeZ8yiHc7jOU9OHok2lggKbSsayJQIMDe8fS2lcftopFsqmDvrXISMh8I4fZaZv3%2BfypzhDOsOORcmNtKe2SUY%2Fq1GqVEucOTWXQqvDyGotZH2qAVQFiRqcSbo0jIGCVZaBbNb5vsMYzKCXbR2clc%2B%2FGgkzujMufQUfxOI0Fi%2B6--VTe8GWPYUoL%2BORIv--PbFURh3l5K2Z2Zuqhq0oaA%3D%3D"
# KITT_COOKIE         = SessionCookie.firefox
STUDENTS_JSON_PATH  = 'kitt_bar_app/config/students.json'

require_relative 'kitt_bar_app/plugin'

Plugin.run(CURRENT_BATCHES, OLD_BATCHES)

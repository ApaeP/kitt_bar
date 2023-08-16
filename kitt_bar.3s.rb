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

CURRENT_BATCHES    = batches.dig('current_batches').map{|batch| batch.transform_keys(&:to_sym)}
OLD_BATCHES        = batches.dig('old_batches').map{|batch| batch.transform_keys(&:to_sym)}
SKILLS             = batches.dig('skills').first.values.flatten.map{|skill| skill.dig("skill_id") if skill.dig("can_do")}.join(",")
KITT_COOKIE        = "_kitt2017_=TLvgXm8lYQ1ToLIKHtrR%2BLDFS2s35iKPTOaOHqUC8S2%2F77kXc69jvQS8an2V7YAZzZKuyhvRI86b36o%2F9tUa7iFmN18%2FG7mx7ogBa72nVq3odVxDICv1wVpz4quWK5ZnD1XUHYORm9Yr6u1rtfk3C9wH0xQpfmYkvKPa4X3HFifjvn4uOnRvSIlW68CIjQYY0GvX2kbW7ByeBG4kE%2BVMjKp%2FmqjbkTNciVPP%2BGstuObcNHKzuts6Myt%2FXPtYKHweEtKPZSxgm51uWLM6NoKz27IImkcrIsPPcqpM%2FSQykdOsxVgCbWZFRpuN9nOevVxosJUE%2FaMW%2Fq8lcOjbd2dqPE%2F3nyJ1s%2BCZNbPX0cZ5KKC0x5K6gZzHJZkpvM0bQO20EzRA3gUJP9c5PNQ8SWEiZ9U6CJ66NCprn1i%2FWDAcI2J9ASoAgJs3ljtT2KFJidyD7bMLNFoAsqLNGqb34sNznpbgvlXBNdSFFWSzDWisXJexERErICELBxgP9cbF9aaCkq5rO9dpctezFco4DgyATAKFieDFjaEYe3cALF63O6gDxJgeRy4eYw5kd7qJGV%2FLUIQ3aQruIHJ0G0yvJuOzaCDDBChsCmOhw3Bi0ct6X%2FaKewv9R%2BKqdA%3D%3D--RhB4333ik0fvJ7Z1--WQIfDrntpoAEhV8VFpdmMg%3D%3D"
# KITT_COOKIE        = SessionCookie.firefox


require_relative 'kitt_bar_app/plugin'

Plugin.run(CURRENT_BATCHES, OLD_BATCHES)

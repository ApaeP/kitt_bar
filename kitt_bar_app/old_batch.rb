require 'net/http'
require 'json'
require_relative 'batch'

class OldBatch < Batch
  attr_reader :slug

  def initialize(attr = {})
    super
  end

  def menu
    puts "--#{menu_name}"
    puts "----Calendar|href=#{calendar_url}"
    puts "----Students|href=#{classmates_url}"
  end
end

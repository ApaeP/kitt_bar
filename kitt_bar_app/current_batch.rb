require 'net/http'
require 'json'
require_relative 'batch'

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(attr = {})
    super
    @errors = []
   	parse_batch_status
  end

  def menu
	  puts "---"
    puts "#{menu_name}"
	  puts "- Tickets|href=#{tickets_url}|size=12"
	  puts "- Calendar|href=#{calendar_url}|size=12"
	  puts "- Students|href=#{classmates_url}|size=12"
  end

  def ticket
    return unless ticket_data = user_ticket

    ticketer = ticket_data.dig('user', 'name')
    table = ticket_data.dig('table')

    "#{ticketer} @ table #{table}"
  end

  def header
    return if @errors.any? || @color == "gray"

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  private

  def tickets_url
    "https://kitt.lewagon.com/camps/#{@slug}/tickets"
  end

  def fetch_api_data
    url       = "https://kitt.lewagon.com/api/v1/camps/#{@slug}/tickets"
    cookie    = KITT_COOKIE
    request   = `curl --cookie \"#{KITT_COOKIE}\" #{url}`
    JSON.parse(request)
  end

  def emoji
    return "🥐" if @lunch_break

    case @color
    when "red"    then "🔴"
    when "orange" then "🟠"
    when "green"  then "🟢"
    else
      "⚫️"
    end
  end

  def user_ticket
    fetch_api_data.dig('tickets').find { |ticket| ticket.dig('is_mine') }
  end

  def parse_batch_status
  	url 	 = URI("https://kitt.lewagon.com/api/v1/camps/#{@slug}/color")
  	status = JSON.parse(Net::HTTP.get(url))

  	@color 			 	= status['color'] == "grey" ? "gray" : status['color']
  	@ticket_count = status['count']
  	@lunch_break  = status['lunch_break']
  rescue => e
    @errors << e
  end
end

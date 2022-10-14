require 'net/http'
require 'json'

class Batch
  class ConnectionError < StandardError; end

  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(slug)
    @slug = slug
    @errors = []
   	parse_batch_status
  end

  def menu
	  puts "---"
	  puts "#{Color.white}Batch ##{@slug}#{Color.reset}"
	  puts "Tickets|href=#{tickets_url}"
	  puts "Calendar|href=#{calendar_url}"
	  puts "Students|href=#{classmates_url}"
  end

  def header
    return if @color == "gray"

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  def tickets_url
    "https://kitt.lewagon.com/camps/#{@slug}/tickets"
  end

  def classmates_url
    "https://kitt.lewagon.com/camps/#{@slug}/classmates"
  end

  def calendar_url
    "https://kitt.lewagon.com/camps/#{@slug}/calendar"
  end

  def emoji
    return "🥐" if @lunch_break

    case @color
    when "red" then "🔴"
    when "orange" then "🟠"
    when "green" then "🟢"
    else
      "⚫️"
    end
  end

  private

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

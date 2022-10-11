require 'net/http'
require 'json'

class Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color

  def initialize(slug)
    @slug = slug
   	parse_batch_status
  end

  def menu
	  puts "---"
	  puts "#{ANSI_COLORS[:white]}Batch ##{@slug}#{ANSI_COLORS[:reset]}"
	  puts "Tickets|href=#{tickets_url}"
	  puts "Calendar|href=#{calendar_url}"
	  puts "Students|href=#{classmates_url}"
  end

  def header
    return if @color == "gray"

  	"#{@slug} #{ANSI_COLORS[@color.to_sym]}#{[emoji, @ticket_count].join(" ")}#{ANSI_COLORS[:reset]}"
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
  end
end

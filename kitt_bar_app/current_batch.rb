require 'open3'
require 'json'
require_relative 'batch'
# `osascript -e'set Volume 10'; afplay #{File.join(File.dirname(__FILE__), 'assets/notification_sound.mp3')}`

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(attr = {})
    super
    @errors = []
    @api_data = fetch_api_data
    @ticket = user_ticket
   	parse_batch_status
  end

  def menu
	  puts "---"
    puts "#{menu_name}|font=bold"
    end_ticket
    tickets
	  puts "🗓 Calendar|href=#{calendar_url}|size=12"
	  puts "🧑‍🎓 Students|href=#{classmates_url}|size=12"
    day_team
  end

  def ticket
    return unless @ticket

    ticketer = @ticket.dig('user', 'name')
    table = @ticket.dig('table')

    "#{ticketer} @ table #{table}"
  end

  def header
    return if @errors.any? || @color == "gray"

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  def tickets
	  puts "🎟 Tickets|href=#{tickets_url}|size=12"    
  end

  def end_ticket
    return unless @ticket

    url = "https://kitt.lewagon.com/api/v1/tickets/#{@ticket['id']}/mark_as_solved"
    puts "✅ Validate ticket|shell=\"#{__dir__}/ticket_validator.rb\" param1=#{KITT_COOKIE} param2=#{url}"
  end

  def day_team
    return if @api_data['on_duties']&.empty? || @api_data['on_duties'].nil?

    puts "🧑‍🏫 Teachers"
    @api_data['on_duties'].each { |teacher| puts "--#{teacher['name']}|href=https://kitt.lewagon.com#{teacher['teacher_path']}" }
  end

  private

  def tickets_url
    "https://kitt.lewagon.com/camps/#{@slug}/tickets"
  end

  def fetch_api_data
    url       = "https://kitt.lewagon.com/api/v1/camps/#{@slug}/tickets"

    request = Open3.capture3("curl --cookie \"#{KITT_COOKIE}\" #{url}").first
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
    @api_data.dig('tickets')&.find { |ticket| ticket.dig('is_mine') }
  end

  def parse_batch_status
  	@color 			 	= @api_data.dig('camp', 'color') == "grey" ? "gray" : @api_data.dig('camp', 'color') || 'gray'
  	@ticket_count = @api_data['tickets']&.count || -1
  	@lunch_break  = @api_data.dig('camp', 'on_lunch_break') || false
  end
end

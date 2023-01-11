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
    return if @errors.any? || @color == "gray" || !batch_open?

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  def tickets
    return puts "- Batch not started" unless batch_open?

	  puts "🎟 Tickets|href=#{tickets_url}|size=12"

    @api_data.dig('tickets').each { |ticket|
      puts "-- #{ticket.dig('user', 'name')} #{assigned_ticket(ticket)}"
      # url = "https://kitt.lewagon.com/api/v1/tickets/#{ticket.dig('id')}/take"
      puts "---- #{Color.orange}take it !#{Color.reset} | #{HttpKitt.put(ticket, "take")}" if ticket.dig('policy', 'current_user_can_take')
      puts "---- #{Color.green}mark as done !#{Color.reset} | #{HttpKitt.put(ticket, "done")}" if ticket.dig('policy', 'current_user_can_mark_as_solved')
      puts "---- #{Color.red}cancel#{Color.reset} | #{HttpKitt.put(ticket, "cancel")}" if ticket.dig('policy', 'current_user_can_cancel')
    }
  end

  def end_ticket
    return unless @ticket
    
    puts "✅ Validate ticket with #{@ticket.dig('user','name')} | #{HttpKitt.put(@ticket, "done")}"
  end

  def day_team
    return if @api_data['on_duties']&.empty? || !batch_open?

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

  def assigned_ticket(ticket)
    return if ticket.dig('assigned', 'id').nil?

    "x #{ ticket.dig('assigned', 'name')}"
  end

  def parse_batch_status
    return unless batch_open?
    
  	@color 			 	= @api_data.dig('camp', 'color') == "grey" ? "gray" : @api_data.dig('camp', 'color') || 'gray'
  	@ticket_count = @api_data.dig('tickets')&.count || -1
  	@lunch_break  = @api_data.dig('camp', 'on_lunch_break') || false
  end

  def batch_open?
    @api_data.dig('status') != 500
  end
end

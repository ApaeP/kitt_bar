require_relative 'batch'
# `osascript -e'set Volume 10'; afplay #{File.join(File.dirname(__FILE__), 'assets/notification_sound.mp3')}`

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(attr = {})
    super
    @api_data = fetch_api_data
    @ticket = user_ticket
   	parse_batch_status
  end

  def menu
	  puts "---"
    puts "#{menu_name}|font=bold"
    if @api_data.dig('status') == 403
      puts "👮 No access to tickets"
    elsif @api_data.dig('status') == 404
      puts "💩 Batch doesn't exist"
    elsif @api_data.dig('status') == 500
      puts "🤖 Server error"
    end
    if batch_open?
      tickets
      day_team
    end
	  puts "🗓 Calendar|href=#{calendar_url}|size=12"
	  puts "🧑‍🎓 Students|href=#{classmates_url}|size=12"
    end_ticket if @ticket
  end

  def ticket
    return unless @ticket

    ticket_requester = @ticket.dig('user', 'name')
    table = @ticket.dig('table')
    "#{ticket_requester} @ table #{table}"
  end

  def header
    return if @color == "gray" || !batch_open?

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  private

  def fetch_api_data
    url = "https://kitt.lewagon.com/api/v1/camps/#{@slug}/tickets"

    request = Open3.capture3("curl --cookie \"#{KITT_COOKIE}\" #{url}").first
    JSON.parse(request)
  rescue
    {'status' => 500}
  end

  def user_ticket
    @api_data.dig('tickets')&.find { |ticket| ticket.dig('is_mine') }
  end

  def parse_batch_status
  	@color 			 	= @api_data.dig('camp', 'color') == "grey" ? "gray" : @api_data.dig('camp', 'color') || 'gray'
  	@ticket_count = @api_data.dig('tickets')&.count || -1
  	@lunch_break  = @api_data.dig('camp', 'on_lunch_break') || false
  end

  def batch_open?
    @api_data && @api_data.dig('status').nil?
  end

  def tickets
    if @api_data.dig('tickets').nil? || @api_data.dig('tickets').empty?
      puts "🎟 #{Color.gray}No tickets yet#{Color.reset}|href=#{tickets_url}|size=12"
    else
  	  puts "🎟 #{@api_data.dig('tickets').size} Ticket#{ 's' if @api_data.dig('tickets').size > 1 }|href=#{tickets_url}|size=12"
      @api_data.dig('tickets').each { |ticket|
        puts "-- #{ticket.dig('user', 'name')} #{assigned_ticket(ticket)}"
        # url = "https://kitt.lewagon.com/api/v1/tickets/#{ticket.dig('id')}/take"
        puts "---- #{Color.orange}take it !#{Color.reset} | #{HttpKitt.put(ticket, "take")}" if ticket.dig('policy', 'current_user_can_take')
        puts "---- #{Color.green}mark as done !#{Color.reset} | #{HttpKitt.put(ticket, "done")}" if ticket.dig('policy', 'current_user_can_mark_as_solved')
        puts "---- #{Color.red}cancel#{Color.reset} | #{HttpKitt.put(ticket, "cancel")}" if ticket.dig('policy', 'current_user_can_cancel')
      }
    end
  end

  def day_team
    return unless @api_data['on_duties'] && !@api_data['on_duties']&.empty?

    puts "🧑‍🏫 Teachers"
    @api_data['on_duties'].each do |teacher|
      puts "--#{teacher['name']}|href=https://kitt.lewagon.com#{teacher['teacher_path']}"
    end
  end

  def end_ticket    
    puts "✅ Validate ticket with #{@ticket.dig('user','name')} | #{HttpKitt.put(@ticket, "done")}"
  end

  def tickets_url
    "https://kitt.lewagon.com/camps/#{@slug}/tickets"
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

  def assigned_ticket(ticket)
    return if ticket.dig('assigned', 'id').nil?

    "x #{ ticket.dig('assigned', 'name')}"
  end
end

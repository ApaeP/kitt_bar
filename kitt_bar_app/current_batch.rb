require_relative 'batch'
require_relative 'ticket'
require_relative 'view'
# `osascript -e'set Volume 10'; afplay #{File.join(File.dirname(__FILE__), 'assets/notification_sound.mp3')}`

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(attr = {})
    super
    @view       = View.new
    @api_data   = fetch_api_data
    @api_status = set_api_status
    @tickets    = generate_tickets
    @ticket     = user_ticket
    parse_batch_status
  end

  def menu
    @view.separator
    @view.append_with(body: menu_name, font: 'bold')
    if @api_status == 403
      @view.append_with(body: "👮 No access to tickets")
    elsif @api_status == 404
      @view.append_with(body: "💩 Batch doesn't exist")
    elsif @api_status == 500
      @view.append_with(body: "🤖 Server error")
    end
    if batch_open?
      tickets
      day_team
      toggle_duty
    end
    @view.append_with(body: '🗓 Calendar', href: calendar_url, size: 12)
    @view.append_with(body: '🧑‍🎓 Classmates', href: classmates_url, size: 12)
    end_ticket if @ticket
  end

  def ticket
    return unless @ticket

    "#{@ticket.student} @ table #{@ticket.table}"
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
    @tickets&.find { |ticket| ticket.is_mine? }
  end

  def parse_batch_status
  	@color 			 	= @api_data.dig('camp', 'color') == "grey" ? "gray" : @api_data.dig('camp', 'color') || 'gray'
  	@ticket_count = @tickets&.count || -1
  	@lunch_break  = @api_data.dig('camp', 'on_lunch_break') || false
  end

  def batch_open?
    @api_data && @api_status.nil?
  end

  def toggle_duty
    return unless @api_data['on_duties']

    if current_user_in_on_duty?
      @view.append_with(body: "🟢 On duty")
      @view.append_with(body: "-- 🍕 take a break", shell: HttpKitt.patch(@slug, "finish"))
    else
      @view.append_with(body: "🔴 Off duty")
      @view.append_with(body: "-- 💻 back to work", shell: HttpKitt.post(@slug, "on_duties"))
    end
  end

  def tickets
    if @tickets.empty?
      @view.append_with(body: "🎟 No tickets yet", href: tickets_url, size: 12, color: "gray")
    else
      @view.append_with(body: "🎟 #{@tickets.size} Ticket#{ 's' if @tickets.size > 1 }", href: tickets_url, size: 12)
      @tickets.each { |ticket|
        @view.append_with(body: "-- #{ticket.student} #{ticket.assigned_teacher}")
        @view.append_with(body: "---- #{ticket.header}")
        ticket.content_formalized.each { |line| @view.append_with(body: "---- #{line}")}
        @view.append_with(body: "---- take it !", color: 'orange', shell: HttpKitt.put(ticket, "take")) if ticket.current_user_can_take
        @view.append_with(body: "---- mark as done !", color: 'green', shell: HttpKitt.put(ticket, "done")) if ticket.current_user_can_mark_as_solved
        @view.append_with(body: "---- cancel", color: 'red', shell: HttpKitt.put(ticket, "cancel")) if ticket.current_user_can_cancel
      }
    end
  end

  def day_team
    return unless @api_data['on_duties'] && !@api_data['on_duties']&.empty?

    @view.append_with(body: "🧑‍🏫 Teachers")
    @api_data['on_duties'].each do |teacher|
      @view.append_with(body: "--#{teacher['name']}", href: "https://kitt.lewagon.com#{teacher['teacher_path']}")
    end
  end

  def end_ticket
    @view.append_with(body: "✅ Validate ticket with #{@ticket.student}", shell: HttpKitt.put(@ticket, "done"))
    @view.append_with(body: "Call #{@ticket.student} on Slack", href: "slack://user?team=#{@ticket.slack_team_id}&id=#{@ticket.owner_slack_uid}") if @ticket.is_remote?
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

  def generate_tickets
    return [] unless @api_data['tickets']

    @api_data.dig('tickets').map {|ticket_data| Ticket.new(ticket_data)}
  end

  def set_api_status
    @api_data.dig('status')
  end

  def current_user_in_on_duty?
    @api_data.dig('on_duties').map { |on_duty| on_duty['id'] }.include?(@api_data.dig('current_user', 'id'))
  end
end


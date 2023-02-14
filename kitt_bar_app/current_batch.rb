require_relative 'batch'
require_relative 'ticket'
# `osascript -e'set Volume 10'; afplay #{File.join(File.dirname(__FILE__), 'assets/notification_sound.mp3')}`

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors

  def initialize(attr = {})
    super
    @api_data   = fetch_api_data
    @api_status = set_api_status
    @tickets    = generate_tickets
    @ticket     = user_ticket
    parse_batch_status
  end

  def menu
    @view.separator
    @view.append_with(body: menu_name, font: 'bold')
    append_batch_status
    if batch_open?
      tickets
      day_team
      toggle_duty
    end
    @view.append_with(body: '🗓 Calendar', href: calendar_url, size: 12)
    @view.append_with(body: '🧑‍🎓 Classmates', href: classmates_url, size: 12)
    @ticket&.close!
    @ticket&.init_slack if @ticket&.is_remote?
  end

  def ticket
    return unless @ticket

    @ticket.plugin_header
  end

  def header
    return if @color == "gray" || !batch_open?

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  private

  def fetch_api_data
    url = "https://kitt.lewagon.com/api/v1/camps/#{@slug}/tickets"

    request = Open3.capture3("curl --cookie \"#{KITT_COOKIE}\" #{url}").first
    JSON.parse(request, symbolize_names: true)
  rescue
    {status: 500}
  end

  def user_ticket
    @tickets&.find(&:is_mine?)
  end

  def parse_batch_status
  	@color 			 	= @api_data.dig(:camp, :color) == "grey" ? "gray" : @api_data.dig(:camp, :color) || 'gray'
  	@ticket_count = @tickets&.count || -1
  	@lunch_break  = @api_data.dig(:camp, :on_lunch_break) || false
  end

  def batch_open?
    @api_data && @api_status.nil?
  end

  def toggle_duty
    return unless @api_data[:on_duties]

    if current_user_in_on_duty?
      @view.append_with(body: "🟢 On duty")
      @view.append_with(body: "-- 🥱 take a break", shell: HttpKitt.patch(@slug, "finish"))
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
        ticket.append_body_and_actions
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
    return [] unless @api_data[:tickets]

    @api_data.dig(:tickets).map {|ticket_data|
      ticket_data[:view] = @view
      Ticket.new(ticket_data)
    }
  end

  def set_api_status
    @api_data.dig(:status)
  end

  def append_batch_status
    batch_status = {
      403 => "👮 No access to tickets",
      404 => "💩 Batch doesn't exist",
      500 => "🤖 Server error"
    }.dig(@api_status)
    @view.append_with(body: batch_status, color: 'red') if batch_status
  end

  def current_user_in_on_duty?
    @api_data.dig(:on_duties).map { |on_duty| on_duty[:id] }.include?(@api_data.dig(:current_user, :id))
  end
end


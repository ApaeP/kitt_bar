require_relative 'batch'
require_relative 'ticket'
# `osascript -e'set Volume 10'; afplay #{File.join(File.dirname(__FILE__), 'assets/notification_sound.mp3')}`

class CurrentBatch < Batch
  attr_reader :slug, :lunch_break, :ticket_count, :color, :errors, :batch_status, :tickets, :ticket, :tickets_url

  def initialize(attr = {})
    super
    @api_data     = fetch_api_data
    @api_status   = set_api_status
    @tickets      = generate_tickets
    @ticket       = user_ticket
    @tickets_url  = set_tickets_url
    @batch_status = get_batch_status
    parse_batch_status
  end

  def current_ticket
    return unless @ticket

    @ticket.plugin_header
  end

  def header
    return if @color == "gray" || !batch_open?

  	"#{@slug} #{Color.send(@color)}#{[emoji, @ticket_count].join(" ")}#{Color.reset}"
  end

  def batch_open?
    @api_data && @api_status.nil?
  end

  def has_team_members?
    !@api_data[:on_duties].empty?
  end

  def current_user_is_on_duty?
    @api_data.dig(:on_duties).map { |on_duty| on_duty[:id] }.include?(@api_data.dig(:current_user, :id))
  end

  def day_team
    @api_data[:on_duties]
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

  def set_tickets_url
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

  def get_batch_status
    status = {
      403 => "👮 No access to tickets",
      404 => "💩 Batch doesn't exist",
      500 => "🤖 Server error"
    }.dig(@api_status)
  end
end


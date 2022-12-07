class HttpKitt
  def initialize
    @kitt_cookie = ENV["KITT_USER_COOKIE"]
    @base_url = "https://kitt.lewagon.com/"
  end

  class << self
    def put(ticket, action)
      new.put(ticket, action)
    end

    def url_for(ticket, action)
      new.url_for(ticket, action)
    end
  end

  def put(ticket, action)
    "#{__dir__}/kitt_request\" param1='PUT' param2=#{@kitt_cookie} param3=#{url_for(ticket, action)}"
  end

  def url_for(ticket, action)
    case action
    when "done"
      path = ticket.dig("routes", "mark_as_solved_api_v1_ticket_path")
    when "take"
      path = ticket.dig("routes", "take_api_v1_ticket_path")
    when "cancel"
      path = ticket.dig("routes", "cancel_api_v1_ticket_path")
    when "leave"
      path = ticket.dig("routes", "leave_api_v1_ticket_path")
    else
      path = ticket.dig("routes", "api_v1_ticket_path")
    end
    "#{@base_url}#{path}"
  end
end

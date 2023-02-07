class HttpKitt
  def initialize
    @kitt_cookie = KITT_COOKIE
    @base_url = "https://kitt.lewagon.com"
  end

  class << self
    def put(ticket, action)
      new.put(ticket, action)
    end

    def post(camp_slug, action)
      new.post(camp_slug, action)
    end

    def patch(camp_slug, action)
      new.patch(camp_slug, action)
    end

    def url_for(params = {})
      new.url_for(params.ticket, params.camp_slug, params.action)
    end
  end

  def put(ticket, action)
    "\"#{__dir__}/kitt_request\" param1=PUT param2=#{@kitt_cookie} param3=#{url_for({ticket: ticket, action: action})}"
  end

  def post(camp_slug, action)
    "\"#{__dir__}/kitt_request\" param1=POST param2=#{@kitt_cookie} param3=#{url_for({camp_slug: camp_slug, action: action})}"
  end

  def patch(camp_slug, action)
    "\"#{__dir__}/kitt_request\" param1=PATCH param2=#{@kitt_cookie} param3=#{url_for({camp_slug: camp_slug, action: action})}"
  end

  def url_for(params = {})
    case params[:action]
    when "done"
      path = params[:ticket].mark_as_solved_api_v1_ticket_path
    when "take"
      path = params[:ticket].take_api_v1_ticket_path
    when "cancel"
      path = params[:ticket].cancel_api_v1_ticket_path
    when "leave"
      path = params[:ticket].leave_api_v1_ticket_path
    when "on_duties"
      path = "/api/v1/camps/#{params[:camp_slug]}/on_duties"
    when "finish"
      path = "/api/v1/camps/#{params[:camp_slug]}/on_duties/finish"
    else
      path = params[:ticket].api_v1_ticket_path
    end
    "#{@base_url}#{path}"
  end
end

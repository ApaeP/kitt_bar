class View
  def append_with(args = {})
    args[:size] = 11 unless args[:size]
    options = args.map { |k, v| "#{k}=#{v}" unless k == :body || k == :color}.compact.join(' | ')
    captures = /\A(-{2,})?(.+)\z/.match(args[:body])&.captures
    level = captures&.first if captures&.length == 2
    body = captures&.last
    body_colorized = args[:color] ? "#{Color.send(args[:color])}#{body}#{Color.reset}" : body
    puts "#{level} #{body_colorized} | #{options}"
  end

  def separator
    puts "---"
  end

  def generate_old_batch_menu(batch)
    append_with(body: "-- #{batch.menu_name}", href: batch.camp_url)
    append_with(body: "---- Calendar", href: batch.calendar_url)
    append_with(body: "---- Students", href: batch.classmates_url)
    append_with(body: "---- Feedbacks", href: batch.feedbacks_url)
  end

  def generate_batch_name_and_status(batch)
    append_with(body: "#{batch.menu_name}", href: batch.camp_url, font: 'bold', size: 12)
    append_with(body: batch.batch_status, color: 'red') if batch.batch_status
  end

  def generate_batch_calendar_and_students(batch)
    append_with(body: '🗓 Calendar', href: batch.calendar_url)
    append_with(body: '🧑‍🎓 Classmates', href: batch.classmates_url)
  end

  def append_tickets(batch_tickets, batch, tickets_url)
    if batch_tickets.empty?
      append_with(body: "🎟 No tickets yet", href: tickets_url, color: "gray")
    else
      append_with(body: "🎟 #{batch_tickets.size} Ticket#{ 's' if batch_tickets.size > 1 }", href: tickets_url)
      batch_tickets.each { |ticket|
        append_a_ticket(ticket)
      }
    end
  end

  def append_a_ticket(ticket)
    append_with(body: "-- #{ticket.student} #{ticket.assigned_teacher}")
    append_with(body: "---- #{ticket.header}")
    ticket.content_formalized.each { |line| append_with(body: "---- #{line}")}
    append_with(body: "---- take it !", color: 'orange', shell: HttpKitt.put(ticket, "take")) if ticket.current_user_can_take
    append_with(body: "---- mark as done !", color: 'green', shell: HttpKitt.put(ticket, "done")) if ticket.current_user_can_mark_as_solved
    append_with(body: "---- cancel", color: 'red', shell: HttpKitt.put(ticket, "cancel")) if ticket.current_user_can_cancel
  end

  def append_day_team(team_hash)
    append_with(body: "🧑‍🏫 Teachers")
    team_hash.each do |teacher|
      append_with(body: "--#{teacher[:name]}", href: "https://kitt.lewagon.com#{teacher[:teacher_path]}")
    end
  end

  def append_toggle_duty(batch, current_user_is_on_duty)
    if current_user_is_on_duty
      append_with(body: "🟢 On duty")
      append_with(body: "-- 🥱 take a break", shell: HttpKitt.patch(batch.slug, "finish"))
    else
      append_with(body: "🔴 Off duty")
      if batch.is_project_week?
        append_with(body: "-- 💻 back to work - projects", shell: HttpKitt.post(batch.slug, "on_duties_projects"))
      else
        append_with(body: "-- 💻 back to work", shell: HttpKitt.post(batch.slug, "on_duties"))
      end
    end
  end

  def append_current_ticket(ticket)
    append_with(body: "✅ Validate ticket with #{ticket.student}", shell: HttpKitt.put(ticket, "done"))
    append_with(body: "Call #{ticket.student} on Slack", href: ticket.slack_url) if ticket.is_remote?
  end
end


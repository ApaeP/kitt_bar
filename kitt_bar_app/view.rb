class View
  def append_with(args = {})
    level = args.delete(:level) || 0
    color = args.delete(:color)
    body  = args.delete(:body)
    args[:size] = args[:size] || 11

    colored_body = color ? "#{Color.send(color)}#{body}#{Color.reset}" : body

    options = args.map { |k, v| "#{k}=#{v}" }.compact.join(' | ')
    puts "#{'--' * level} #{colored_body} | #{options}"
  end

  def separator
    puts "---"
  end

  def generate_old_batch_menu(batch)
    append_with(level: 1, body: "#{batch.menu_name}", href: batch.camp_url)
    append_with(level: 2, body: "Calendar", href: batch.calendar_url)
    append_with(level: 2, body: "Students", href: batch.classmates_url)
    append_with(level: 2, body: "Feedbacks", href: batch.feedbacks_url)
  end

  def sub_menu
		separator
    append_with(body: "Profile", size: 12)
    append_with(body: "Calendar", href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/calendar", level: 1)
    append_with(body: "Invoices", href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/invoices", level: 1)
		separator
    append_with(body: "Tools", size: 12)
    append_with(body: "Database schemas", href: "https://kitt.lewagon.com/db", level: 1)
		separator
    append_with(body: "Links", size: 12)
    append_with(body: "Paris Web Hall of Fame", href: "https://kitt.lewagon.com/cities/paris/teachers/web?camp_slugs[]=0&camp_slugs[]=1&camp_slugs[]=10&camp_slugs[]=100&camp_slugs[]=1000&camp_slugs[]=1003&camp_slugs[]=101&camp_slugs[]=1030&camp_slugs[]=11&camp_slugs[]=1115&camp_slugs[]=1116&camp_slugs[]=1170&camp_slugs[]=120&camp_slugs[]=1210&camp_slugs[]=1211&camp_slugs[]=1309&camp_slugs[]=1312&camp_slugs[]=134&camp_slugs[]=145&camp_slugs[]=146&camp_slugs[]=15&camp_slugs[]=177&camp_slugs[]=18&camp_slugs[]=2&camp_slugs[]=200&camp_slugs[]=201&camp_slugs[]=220&camp_slugs[]=221&camp_slugs[]=232&camp_slugs[]=24&camp_slugs[]=250&camp_slugs[]=251&camp_slugs[]=290&camp_slugs[]=291&camp_slugs[]=3&camp_slugs[]=30&camp_slugs[]=301&camp_slugs[]=320&camp_slugs[]=321&camp_slugs[]=350&camp_slugs[]=351&camp_slugs[]=378&camp_slugs[]=4&camp_slugs[]=400&camp_slugs[]=401&camp_slugs[]=422&camp_slugs[]=43&camp_slugs[]=440&camp_slugs[]=441&camp_slugs[]=460&camp_slugs[]=48&camp_slugs[]=5&camp_slugs[]=500&camp_slugs[]=501&camp_slugs[]=550&camp_slugs[]=551&camp_slugs[]=554&camp_slugs[]=59&camp_slugs[]=590&camp_slugs[]=591&camp_slugs[]=6&camp_slugs[]=636&camp_slugs[]=660&camp_slugs[]=70&camp_slugs[]=703&camp_slugs[]=724&camp_slugs[]=729&camp_slugs[]=730&camp_slugs[]=731&camp_slugs[]=8&camp_slugs[]=800&camp_slugs[]=801&camp_slugs[]=810&camp_slugs[]=811&camp_slugs[]=83&camp_slugs[]=860&camp_slugs[]=861&camp_slugs[]=940&camp_slugs[]=984&", level: 1)
    append_with(body: "Alumni", href: "https://kitt.lewagon.com/alumni", level: 1)
    append_with(body: "World map", href: "https://kitt.lewagon.com/alumni/staff", level: 1)
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
      batch_tickets.each { |ticket| append_ticket(ticket) }
    end
  end

  def append_ticket(ticket)
    append_with(level: 1, body: "#{ticket.student} #{ticket.assigned_teacher}")
    append_with(level: 2, body: "#{ticket.header}")
    ticket.content_formalized.each { |line| append_with(level: 2, body: " #{line}")}
    append_with(level: 2, body: "take it !", color: 'orange', shell: HttpKitt.put(ticket, "take")) if ticket.current_user_can_take
    append_with(level: 2, body: "mark as done !", color: 'green', shell: HttpKitt.put(ticket, "done")) if ticket.current_user_can_mark_as_solved
    append_with(level: 2, body: "cancel", color: 'red', shell: HttpKitt.put(ticket, "cancel")) if ticket.current_user_can_cancel
  end

  def append_day_team(team_hash)
    append_with(body: "🧑‍🏫 Teachers")
    team_hash.each do |teacher|
      append_with(level: 1, body: "#{teacher[:name]}", href: "https://kitt.lewagon.com#{teacher[:teacher_path]}")
    end
  end

  def append_toggle_duty(batch, current_user_is_on_duty)
    if current_user_is_on_duty
      append_with(body: "🟢 On duty")
      append_with(level: 1, body: "🥱 take a break", shell: HttpKitt.patch(batch.slug, "finish"))
    else
      append_with(body: "🔴 Off duty")
      if batch.is_project_week?
        append_with(level: 1, body: "💻 back to work - projects", shell: HttpKitt.post(batch.slug, "on_duties_projects"))
      else
        append_with(level: 1, body: "💻 back to work", shell: HttpKitt.post(batch.slug, "on_duties"))
      end
    end
  end

  def append_current_ticket(ticket)
    append_with(body: "✅ Validate ticket with #{ticket.student}", shell: HttpKitt.put(ticket, "done"))
    append_with(body: "Call #{ticket.student} on Slack", href: ticket.slack_url) if ticket.is_remote?
  end
end


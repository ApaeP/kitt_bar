class View
  def display(string, args = {})
    level = args.delete(:level) || 0
    color = args.delete(:color)
    args[:size] = args[:size] || 11

    string  = "#{Color.send(color)}#{string}#{Color.reset}" unless color.nil?
    options = args.map { |k, v| "#{k}=#{v}" }.compact.join(' | ')

    puts "#{'--' * level} #{string} | #{options}"
  end

  def separator
    puts "---"
  end

  def generate_old_batch_menu(batch)
    display("#{batch.menu_name}", href: batch.camp_url, level: 1)
    display("Calendar", href: batch.calendar_url, level: 2)
    display("Students", href: batch.classmates_url, level: 2)
    display("Feedbacks", href: batch.feedbacks_url, level: 2)
  end

  def sub_menu
		separator
    display("Profile", size: 12)
    display("Calendar", href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/calendar", level: 1)
    display("Invoices", href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/invoices", level: 1)
		separator
    display("Tools", size: 12)
    display("Database schemas", href: "https://kitt.lewagon.com/db", level: 1)
		separator
    display("Links", size: 12)
    display("Paris Web Hall of Fame", href: "https://kitt.lewagon.com/cities/paris/teachers/web?camp_slugs[]=0&camp_slugs[]=1&camp_slugs[]=10&camp_slugs[]=100&camp_slugs[]=1000&camp_slugs[]=1003&camp_slugs[]=101&camp_slugs[]=1030&camp_slugs[]=11&camp_slugs[]=1115&camp_slugs[]=1116&camp_slugs[]=1170&camp_slugs[]=120&camp_slugs[]=1210&camp_slugs[]=1211&camp_slugs[]=1309&camp_slugs[]=1312&camp_slugs[]=134&camp_slugs[]=145&camp_slugs[]=146&camp_slugs[]=15&camp_slugs[]=177&camp_slugs[]=18&camp_slugs[]=2&camp_slugs[]=200&camp_slugs[]=201&camp_slugs[]=220&camp_slugs[]=221&camp_slugs[]=232&camp_slugs[]=24&camp_slugs[]=250&camp_slugs[]=251&camp_slugs[]=290&camp_slugs[]=291&camp_slugs[]=3&camp_slugs[]=30&camp_slugs[]=301&camp_slugs[]=320&camp_slugs[]=321&camp_slugs[]=350&camp_slugs[]=351&camp_slugs[]=378&camp_slugs[]=4&camp_slugs[]=400&camp_slugs[]=401&camp_slugs[]=422&camp_slugs[]=43&camp_slugs[]=440&camp_slugs[]=441&camp_slugs[]=460&camp_slugs[]=48&camp_slugs[]=5&camp_slugs[]=500&camp_slugs[]=501&camp_slugs[]=550&camp_slugs[]=551&camp_slugs[]=554&camp_slugs[]=59&camp_slugs[]=590&camp_slugs[]=591&camp_slugs[]=6&camp_slugs[]=636&camp_slugs[]=660&camp_slugs[]=70&camp_slugs[]=703&camp_slugs[]=724&camp_slugs[]=729&camp_slugs[]=730&camp_slugs[]=731&camp_slugs[]=8&camp_slugs[]=800&camp_slugs[]=801&camp_slugs[]=810&camp_slugs[]=811&camp_slugs[]=83&camp_slugs[]=860&camp_slugs[]=861&camp_slugs[]=940&camp_slugs[]=984&", level: 1)
    display("Alumni", href: "https://kitt.lewagon.com/alumni", level: 1)
    display("World map", href: "https://kitt.lewagon.com/alumni/staff", level: 1)
	end

  def generate_batch_name_and_status(batch)
    display("#{batch.menu_name}", href: batch.camp_url, font: 'bold', size: 12)
    display(batch.batch_status, color: 'red') if batch.batch_status
  end

  def generate_batch_calendar_and_students(batch)
    display('🗓 Calendar', href: batch.calendar_url)
    display('🧑‍🎓 Classmates', href: batch.classmates_url)
  end

  def append_tickets(batch_tickets, batch, tickets_url)
    if batch_tickets.empty?
      display("🎟 No tickets yet", href: tickets_url, color: "gray")
    else
      display("🎟 #{batch_tickets.size} Ticket#{ 's' if batch_tickets.size > 1 }", href: tickets_url)
      batch_tickets.each { |ticket| append_ticket(ticket) }
    end
  end

  def append_ticket(ticket)
    display("#{ticket.student} #{ticket.assigned_teacher}", level: 1)
    display("#{ticket.header}", level: 2)
    ticket.content_formalized.each { |line| display(" #{line}", level: 2) }
    display("take it !", color: 'orange', shell: HttpKitt.put(ticket, "take"), level: 2) if ticket.current_user_can_take
    display("mark as done !", color: 'green', shell: HttpKitt.put(ticket, "done"), level: 2) if ticket.current_user_can_mark_as_solved
    display("cancel", color: 'red', shell: HttpKitt.put(ticket, "cancel"), level: 2) if ticket.current_user_can_cancel
  end

  def append_day_team(team_hash)
    display("🧑‍🏫 Teachers")
    team_hash.each do |teacher|
      display("#{teacher[:name]}", href: "https://kitt.lewagon.com#{teacher[:teacher_path]}", level: 1)
    end
  end

  def append_toggle_duty(batch, current_user_is_on_duty)
    if current_user_is_on_duty
      display("🟢 On duty")
      display("🥱 take a break", shell: HttpKitt.patch(batch.slug, "finish"), level: 1)
    else
      display("🔴 Off duty")
      if batch.is_project_week?
        display("💻 back to work - projects", shell: HttpKitt.post(batch.slug, "on_duties_projects"), level: 1)
      else
        display("💻 back to work", shell: HttpKitt.post(batch.slug, "on_duties"), level: 1)
      end
    end
  end

  def append_toggle_lunch(batch)
    if batch.is_on_lunch_break?
      append_with(body: "🍔 Lunch break in #{batch.lunch_end_in_minutes} minutes")
      append_with(body: "-- 💻 back to work !",  shell: HttpKitt.patch(batch.slug, "toggle_lunch"))
    else
      append_with(body: "💻 Working hard")
      append_with(body: "-- 🍔 lunch break !",  shell: HttpKitt.patch(batch.slug, "toggle_lunch"))
    end
  end

  def append_current_ticket(ticket)
    display("✅ Validate ticket with #{ticket.student}", shell: HttpKitt.put(ticket, "done"))
    display("Call #{ticket.student} on Slack", href: ticket.slack_url) if ticket.is_remote?
  end
end


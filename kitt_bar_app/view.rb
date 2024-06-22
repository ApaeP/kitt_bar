# frozen_string_literal: true

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
    puts '---'
  end

  def generate_old_batch_menu(batch)
    display(batch.menu_name, href: batch.camp_url, level: 1)
    display('Calendar', href: batch.calendar_url, level: 2)
    display('Students', href: batch.classmates_url, level: 2)
    display('Feedbacks', href: batch.feedbacks_url, level: 2)
  end

  def sub_menu
    separator
    display('Profile', size: 12)
    display('Calendar', href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/calendar", level: 1)
    display('Invoices', href: "https://kitt.lewagon.com/alumni/#{GITHUB_USERNAME}/invoices", level: 1)
    separator
    display('Tools', size: 12)
    display('Database schemas', href: 'https://kitt.lewagon.com/db', level: 1)
    separator
    display('Links', size: 12)
    display('Paris Web Hall of Fame', href: paris_web_hall_of_fame_path, level: 1)
    display('Alumni', href: 'https://kitt.lewagon.com/alumni', level: 1)
    display('World map', href: 'https://kitt.lewagon.com/alumni/staff', level: 1)
  end

  def generate_batch_name_and_status(batch)
    display(batch.menu_name, href: batch.camp_url, font: 'bold', size: 12)
    display(batch.batch_status, color: 'red') if batch.batch_status
  end

  def generate_batch_calendar_and_students(batch)
    display('🗓 Calendar', href: batch.calendar_url)
    display('🧑‍🎓 Classmates', href: batch.classmates_url)
  end

  def append_tickets(batch_tickets, _batch, tickets_url)
    if batch_tickets.empty?
      display('🎟 No tickets yet', href: tickets_url, color: 'gray')
    else
      display("🎟 #{batch_tickets.size} Ticket#{'s' if batch_tickets.size > 1}", href: tickets_url)
      batch_tickets.each { |ticket| append_ticket(ticket) }
    end
  end

  def append_ticket(ticket)
    display("#{ticket.student} #{ticket.assigned_teacher}", level: 1)
    display(ticket.header, level: 2)
    ticket.content_formalized.each { |line| display(" #{line}", level: 2) }
    display('take it !', color: 'orange', shell: HttpKitt.put(ticket, 'take'), level: 2) if ticket.current_user_can_take
    if ticket.current_user_can_mark_as_solved
      display('mark as done !', color: 'green', shell: HttpKitt.put(ticket, 'done'),
                                level: 2)
    end
    display('cancel', color: 'red', shell: HttpKitt.put(ticket, 'cancel'), level: 2) if ticket.current_user_can_cancel
  end

  def append_day_team(team_hash)
    display('🧑‍🏫 Teachers')
    team_hash.each do |teacher|
      display(teacher[:name], href: "https://kitt.lewagon.com#{teacher[:teacher_path]}", level: 1)
    end
  end

  def append_toggle_duty(batch, current_user_is_on_duty)
    if current_user_is_on_duty
      display('🟢 On duty')
      display('🥱 take a break', shell: HttpKitt.patch(batch.slug, 'finish'), level: 1)
    else
      display('🔴 Off duty')
      if batch.is_project_week?
        display('💻 back to work - projects', shell: HttpKitt.post(batch.slug, 'on_duties_projects'), level: 1)
      else
        display('💻 back to work', shell: HttpKitt.post(batch.slug, 'on_duties'), level: 1)
      end
    end
  end

  def append_current_ticket(ticket)
    display("✅ Validate ticket with #{ticket.student}", shell: HttpKitt.put(ticket, 'done'))
    display("Call #{ticket.student} on Slack", href: ticket.slack_url) if ticket.is_remote?
  end

  def paris_web_hall_of_fame_path
    batches = [0, 1, 2, 3, 4, 5, 6, 8, 10, 11, 15, 18, 24, 30, 43, 48, 59, 70, 83, 100, 101, 120, 134, 145, 146, 177,
               200, 201, 220, 221, 232, 250, 251, 290, 291, 301, 320, 321, 350, 351, 378, 400, 401, 422, 440, 441, 460,
               500, 501, 550, 551, 554, 590, 591, 636, 660, 703, 724, 729, 730, 731, 800, 801, 810, 811, 860, 861, 940,
               984, 1000, 1003, 1030, 1115, 1116, 1170, 1210, 1211, 1309, 1312, 1367, 1371, 1410, 1411, 1511, 1540, 1670,
               1721
              ]
    batches_query = batches.map { |batch| "camp_slugs[]=#{batch}" }.join('&')
    "https://kitt.lewagon.com/cities/paris/teachers/web?#{batches_query}"
  end
end

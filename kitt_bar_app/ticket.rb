class Ticket
  attr_reader :content,
              :table,
              :student,
              :teacher,
              :exercice_name,
              :current_user_can_take,
              :current_user_can_leave,
              :current_user_can_update,
              :current_user_can_cancel,
              :current_user_can_mark_as_solved,
              :api_v1_ticket_path,
              :cancel_api_v1_ticket_path,
              :mark_as_solved_api_v1_ticket_path,
              :leave_api_v1_ticket_path,
              :take_api_v1_ticket_path

  def initialize(attr = {})
    @view = attr.dig(:view)
    @content = attr.dig(:content)
    @table = attr.dig(:table)
    @student = attr.dig(:user, :name)
    @teacher =  attr.dig(:assigned, :name)
    @is_mine = attr.dig(:is_mine)
    @remote = attr.dig(:remote)
    @exercice_name = attr.dig(:exercice_name)
    @owner_slack_uid = attr.dig(:owner_slack_uid)
    @slack_team_id = attr.dig(:slack_team_id)
    @current_user_can_take = attr.dig(:policy, :current_user_can_take)
    @current_user_can_leave = attr.dig(:policy, :current_user_can_leave)
    @current_user_can_update = attr.dig(:policy, :current_user_can_update)
    @current_user_can_cancel = attr.dig(:policy, :current_user_can_cancel)
    @current_user_can_mark_as_solved = attr.dig(:policy, :current_user_can_mark_as_solved)
    @api_v1_ticket_path = attr.dig(:routes, :api_v1_ticket_path)
    @cancel_api_v1_ticket_path = attr.dig(:routes, :cancel_api_v1_ticket_path)
    @mark_as_solved_api_v1_ticket_path = attr.dig(:routes, :mark_as_solved_api_v1_ticket_path)
    @leave_api_v1_ticket_path = attr.dig(:routes, :leave_api_v1_ticket_path)
    @take_api_v1_ticket_path = attr.dig(:routes, :take_api_v1_ticket_path)
  end

  def slack_url
    "slack://user?team=#{@slack_team_id}&id=#{@owner_slack_uid}"
  end

  def assigned_teacher
    return unless self.teacher

    "x #{self.teacher}"
  end

  def header
    "#{'REMOTE - ' if self.is_remote?}#{self.table ? "table #{self.table}" : 'no table'}"
  end

  def plugin_header
    "#{self.student} @ table #{self.table}"
  end

  def is_remote?
    @remote
  end

  def is_mine?
    @is_mine
  end

  def sanitize
    self.content.gsub(/[\n\r"#:{}|]/, "")
  end

  def content_formalized
    ticket_content = self.sanitize.split('').each_slice(40).to_a
    ticket_content.each_with_index do |slice, index|
      loop do
        break if  (slice.last == " " && slice.length <= 40) || # break if line is perfect
                  (!slice.include?(" ")) || # break loop to go to cutting line
                  (!ticket_content[index + 1]) # break if last line of message
        ticket_content[index + 1].unshift(slice.pop)
      end
      # when line is still too long with no space :
      # 1. keep first part 2. give the rest to next line
      if slice.length > 40
        slice = ticket_content[index]
        ticket_content[index] = slice.each_slice(40).to_a[0] # keep first part
        if ticket_content[index + 1]
          ticket_content[index + 1].unshift(slice.each_slice(40).to_a.pop[0]) # give the rest to next line
        else
          slice.each_slice(40).to_a.each {|new_slice| ticket_content << new_slice }
        end
      end
    end
    ticket_content.map(&:join).map(&:strip)
  end
end

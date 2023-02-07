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
    @content = attr["content"]
    @table = attr["table"]
    @student = attr["user"]["name"]
    @teacher =  attr["assigned"]["name"]  if attr["assigned"]
    @is_mine = attr["is_mine"]
    @remote = attr["remote"]
    @exercice_name = attr["exercice_name"]
    @owner_slack_uid = attr["owner_slack_uid"]
    @slack_team_id = attr["slack_team_id"]
    @current_user_can_take = attr["policy"]["current_user_can_take"]
    @current_user_can_leave = attr["policy"]["current_user_can_leave"]
    @current_user_can_update = attr["policy"]["current_user_can_update"]
    @current_user_can_cancel = attr["policy"]["current_user_can_cancel"]
    @current_user_can_mark_as_solved = attr["policy"]["current_user_can_mark_as_solved"]
    @api_v1_ticket_path = attr["routes"]["api_v1_ticket_path"]
    @cancel_api_v1_ticket_path = attr["routes"]["cancel_api_v1_ticket_path"]
    @mark_as_solved_api_v1_ticket_path = attr["routes"]["mark_as_solved_api_v1_ticket_path"]
    @leave_api_v1_ticket_path = attr["routes"]["leave_api_v1_ticket_path"]
    @take_api_v1_ticket_path = attr["routes"]["take_api_v1_ticket_path"]
  end

  def slack_url
    "slack://user?team=#{@slack_team_id}&id=#{@owner_slack_uid}"
  end

  def assigned_teacher
    return unless self.teacher

    "x #{self.teacher}"
  end

  def header
    "#{'REMOTE | ' if self.is_remote?}#{self.table ? "table #{self.table}" : 'no table'}"
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

  def is_remote?
    @remote
  end

  def is_mine?
    @is_mine
  end

  def sanitize
    self.content.gsub("\n", " ").gsub("\r", " ").gsub('"', "'").gsub('#{', "{")
  end
end

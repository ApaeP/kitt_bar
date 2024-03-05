require_relative 'student'

class Ticket
  attr_reader :content,
              :table,
              :student,
              :student_avatar,
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
    @student = find_or_create_student(attr.dig(:user))
    # @student = attr.dig(:user, :name)
    # @student_avatar = attr.dig(:user, :avatar_url)
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
    "#{self.student} @ #{self.table ? "table #{self.table}" : 'no table'}"
  end

  def is_remote?
    @remote
  end

  def is_mine?
    FULL_NAME == @teacher
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

  private

  def find_or_create_student(student) # student is the :user attached to a ticket
    student_id = student.dig(:id).to_s
    avatar_url = student.dig(:avatar_url)
    student_name = student.dig(:name)

    # filepath = 'kitt_bar_app/config/students.json'
    # load json file
    students_serialized = File.read(STUDENTS_JSON_PATH)
    all_students        = JSON.parse(students_serialized)
    # if user found in students_json build user/student instance and return it
    if student_from_json = all_students[student_id]
      student_hash = {
        id: student_id,
        name: student_name,
        avatar_url: avatar_url,
        avatar_base: student_from_json["avatar_base"]
      }
      std = Student.new(student_hash)
    else # else add user to json before building and returning student instance
      # generating avatar base64 + resizing SOON
      avatar_base = ImageHandler.textfile(avatar_url)

      student_hash = {
        name: student_name,
        avatar_url: avatar_url,
        avatar_base: avatar_base
      }
      all_students[student_id] = student_hash
      # save json
      File.open(STUDENTS_JSON_PATH, "wb") do |file|
        file.write(JSON.generate(all_students))
      end

      student_hash[:id] = student_id
      std = Student.new(student_hash)
    end
    # returns a student instance created or found
    return std
  end
end

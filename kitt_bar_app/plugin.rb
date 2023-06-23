require_relative 'current_batch'
require_relative 'old_batch'
require_relative 'view'

class Plugin
	class << self
		def run(current_batches, old_batches)
			new(current_batches, old_batches).generate
		end
	end

	def initialize(current_batches, old_batches)
    @view = View.new
		@current_batches  = current_batches
		@old_batches_info = old_batches
		initialize_batches
		initialize_old_batches
	end

	def generate
		header
		current_batch_menus
		old_batches_menu
		@view.sub_menu
	end

	private

	def initialize_batches
		@batches = @current_batches.map do |batch|
      batch[:view] = @view
			CurrentBatch.new(batch)
		end
	end

	def header
		headers = @batches.map(&:header).compact
		if headers.empty?
			puts "😴"
		else
			puts "#{headers.join(" #{Color.darkgray}❖#{Color.reset} ")}#{' - ' unless tickets.empty? }#{tickets}"
		end
		puts "---"
	end

	def tickets
		@batches.map(&:current_ticket).compact.join(', ')
	end

	def batch_headers
		@batches.map(&:header).compact
	end

	def current_batch_menus
		@batches.each do |batch|
      @view.separator
      @view.generate_batch_name_and_status(batch)
      if batch.batch_open?
        @view.append_tickets(batch.tickets, batch, batch.tickets_url)
        if batch.day_team
          @view.append_day_team(batch.day_team) if batch.has_team_members?
          @view.append_toggle_duty(batch, batch.current_user_is_on_duty?)
        end
      end
      @view.generate_batch_calendar_and_students(batch)
      if ticket = batch.ticket
        @view.append_current_ticket(ticket)
      end
    end
	end

	def initialize_old_batches
		@old_batches = @old_batches_info
			.sort_by { |e| e[:slug] }.reverse
			.map { |batch| OldBatch.new(batch) }
	end

	def old_batches_menu
    @view.separator
    @view.append_with(body: "Old Batches")
		@old_batches.each { |batch| @view.generate_old_batch_menu(batch) }
	end
end

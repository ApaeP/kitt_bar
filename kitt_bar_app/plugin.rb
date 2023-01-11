require_relative 'current_batch'
require_relative 'old_batch'

class Plugin
	class << self
		def run(current_batches, old_batches)
			new(current_batches, old_batches).generate
		end
	end

	def initialize(current_batches, old_batches)
		@current_batches = current_batches
		@old_batches_info = old_batches
		initialize_batches
		initialize_old_batches
	end

	def generate		
		header
		menu
		old_batches_menu
	end

	private

	def initialize_batches
		@batches = @current_batches.map do |batch| 
			CurrentBatch.new(batch)
		end
	end

	def header
		headers = @batches.map(&:header).compact
		if headers.empty?
			puts "#{Color.darkgray}😴#{Color.reset}"
		else
			puts "#{headers.join(" #{Color.darkgray}❖#{Color.reset} ")}#{' - ' unless tickets.empty? }#{tickets}"
		end
		puts "---"
	end

	def tickets
		@batches.map(&:ticket).compact.join(', ')
	end

	def batch_headers
		@batches.map(&:header).compact
	end

	def menu
		@batches.each(&:menu)
	end

	def initialize_old_batches
		@old_batches = @old_batches_info
			.sort_by { |e| e[:slug] }.reverse
			.map { |batch| OldBatch.new(batch) }
	end

	def old_batches_menu
		puts "---"
		puts "Old batches"
		@old_batches.each(&:menu)
	end
end

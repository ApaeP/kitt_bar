require_relative 'current_batch'
require_relative 'old_batch'

class Plugin
	class << self
		def run(batch_infos, old_batches_infos)
			new(batch_infos, old_batches_infos).generate
		end
	end

	def initialize(batch_infos, old_batches_infos)
		@batch_infos = batch_infos
		@old_batches_info = old_batches_infos
		initialize_batches
		initialize_old_batches
	end

	def generate		
		display_errors && return if network_error?
		
		header
		menu
		old_batches_menu
	end

	def display_errors
		puts "❌ Error ❌".red
		puts "---"
		puts @batches.map(&:errors).join(', ')
	end

	private

	def initialize_batches
		@batches = @batch_infos.map { |batch_info| CurrentBatch.new(batch_info) }
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
			.map { |batch_info| OldBatch.new(batch_info) }
	end

	def old_batches_menu
		puts "---"
		puts "Old batches"
		@old_batches.each(&:menu)
	end

	def network_error?
		return false
		CurrentBatch.new(0).errors.any?
	end
end

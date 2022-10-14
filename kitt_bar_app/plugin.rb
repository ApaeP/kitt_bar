require_relative 'batch'

class Plugin
	class << self
		def call(slugs)
			new(slugs).generate
		end
	end

	def initialize(slugs)
		@slugs = slugs
		initialize_batches
	end

	def generate		
		puts "❌ network error".red && return if network_error?
		
		header
		menu
	end

	private

	def header
		headers = @batches.map(&:header).compact
		if headers.empty?
			puts "#{Color.darkgray}😴#{Color.reset}"
		else
			puts "#{headers.join(" #{Color.darkgray}❖#{Color.reset} ")}"
		end
		puts "---"
	end

	def menu
		@batches.each(&:menu)
	end

	def initialize_batches
		@batches = @slugs.map do |slug| 
			batch = Batch.new(slug) 
		end
	end

	def network_error?
		Batch.new(0).errors.any?
	end
end

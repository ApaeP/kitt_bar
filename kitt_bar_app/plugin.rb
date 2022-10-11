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
		header
		menu
	end

	private

	def header
		headers = @batches.map(&:header).compact
		if headers.empty?
			puts "#{ANSI_COLORS[:darkgray]}😴#{ANSI_COLORS[:reset]}"
		else
			puts "#{headers.join(" #{ANSI_COLORS[:darkgray]}❖#{ANSI_COLORS[:reset]} ")}"
		end
		puts "---"
	end

	def menu
		@batches.each(&:menu)
	end

	def initialize_batches
		@batches = @slugs.map { |slug| Batch.new(slug) }
	end
end

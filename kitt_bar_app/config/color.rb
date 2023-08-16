class Color
	COLORS = Hash.new { |hash, key| "\e[38;5;#{key}m" }.merge({
	  green: "\e[38;5;76m",
	  red: "\e[38;5;160m",
	  orange: "\e[38;5;214m",
	  darkgray: "\e[38;5;240m",
	  gray: "\e[38;5;245m",
	  lightgray: "\e[38;5;250m",
	  white: "\e[38;5;255m",
	  reset: "\u001b[0m"
	})
	
	class << self
		def base(value)
			"\e[38;5;#{value}m"
		end

		COLORS.each do |k, v|
			define_method(k, -> {v})
		end
	end
end

class Color
	class << self
		ANSI_COLORS.each do |k, v|
			define_method(k, -> {v})
		end
	end
end

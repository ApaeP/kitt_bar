class String
	ANSI_COLORS.each do |k, v|
		define_method(k, -> { "#{Color.send(k)}#{self}#{Color.reset}" })
	end
end

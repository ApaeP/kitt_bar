# frozen_string_literal: true

class String
  Color::COLORS.each_key do |k|
    define_method(k, -> { "#{Color.send(k)}#{self}#{Color.reset}" })
  end
end

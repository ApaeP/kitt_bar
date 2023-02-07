class View
  def append_with(args = {})
    options = args.map { |k, v| "#{k}=#{v}" unless k == :body || k == :color}.compact.join(' | ')
    captures = /\A(-{2,})?(.+)\z/.match(args[:body])&.captures
    level = captures&.first if captures&.length == 2
    body = captures&.last
    body_colorized = args[:color] ? "#{Color.send(args[:color])}#{body}#{Color.reset}" : body
    puts "#{level} #{body_colorized} | #{options}"
  end

  def separator
    puts "---"
  end
end

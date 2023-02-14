class Batch
  def initialize(attr = {})
    @slug = attr[:slug]
    @type = attr[:type]
    @city = attr[:city]
    @cursus = attr[:cursus]
    @view = attr[:view]
  end

  def menu_name
    "#{@slug} #{menu_cursus} #{menu_type} - #{@city}|href=https://kitt.lewagon.com/camps/#{@slug}|"
  end

  def type_color
    case @type
    when 'FT' then 148
    when 'PT' then 135
    end
  end

  def menu_type
    "#{Color.base(type_color)}#{@type}#{Color.reset}"
  end

  def cursus_color
    case @cursus
    when 'Web' then 32
    when 'Data Analytics' then 6
    when 'Data Science' then 87
    end
  end

  def menu_cursus
    "#{Color.base(cursus_color)}#{@cursus}#{Color.reset}"
  end

  def menu_city
    "#{Color.base(32)}##{@city}#{Color.reset}"
  end

  def classmates_url
    "https://kitt.lewagon.com/camps/#{@slug}/classmates"
  end

  def calendar_url
    "https://kitt.lewagon.com/camps/#{@slug}/calendar"
  end
end

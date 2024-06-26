# frozen_string_literal: true

class Batch
  def initialize(attr = {})
    @slug = attr[:slug]
    @type = attr[:type]
    @city = attr[:city]
    @cursus = attr[:cursus]
    @view = attr[:view]
  end

  def menu_name
    "#{@slug} #{menu_cursus} #{menu_type} - #{@city}"
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
    {
      "Web" => 32,
      "Data Analytics" => 6,
      "Data Science" => 87
    }[@cursus]
  end

  def menu_cursus
    "#{Color.base(cursus_color)}#{@cursus}#{Color.reset}"
  end

  def camp_url
    "https://kitt.lewagon.com/camps/#{@slug}"
  end

  def classmates_url
    "#{camp_url}/classmates"
  end

  def calendar_url
    "#{camp_url}/calendar"
  end
end

class Student
  attr_accessor :id, :name, :avatar_url, :avatar_base

  def initialize(attr = {})
    @id           = attr.dig(:id)
    @name         = attr.dig(:name)
    @avatar_url   = attr.dig(:avatar_url)
    @avatar_base  = attr.dig(:avatar_base)
  end
end

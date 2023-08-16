class ImageHandler
  attr_accessor :path

  class << self
    def textfile(filepath)
      new(filepath).textfile
    end
  end

  def initialize(path, options = {})
    @path = path
    # options for size at some point 🤷
  end

  def textfile
    write_file
  end

  private

  def write_file
    Base64.encode64(URI.open(@path).read).delete("\n")
  end
end

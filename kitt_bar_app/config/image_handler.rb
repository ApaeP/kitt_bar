class ImageHandler
  attr_accessor :path

  class << self
    def textfile(filepath)
      new(filepath).textfile
    end
  end

  def initialize(path)
    @path = path
  end

  def textfile
    write_file

    # with resizing -> with gem 'rmagick'
    # image = resize_image
    # write_file(image)
  end

  private

  def write_file
    Base64.encode64(@path).delete("\n")
  end

  # these two methods should handle the resizing of images before writing as Base64
  # but I keep getting errors related to ImageMagick or Graphick something
  
  # def write_file(image_blob)
  #   Base64.encode64(image_blob).delete("\n") # writing file from image blob as a Base64
  # end

  # def resize_image
  #   image = MiniMagick::Image.open(@path)
  #   image.resize "100x100"
  #   image.format "png"
  #   return image.to_blob # return image needed as a blob instead of saving it
  # end
end

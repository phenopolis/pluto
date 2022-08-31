require "gd"

module Pluto::Formats::JPEG
  macro included
    def self.from_jpeg(image_data) : self
      gd_image_pointer = LibGD.image_create_from_jpeg_ptr(image_data.bytesize, image_data)
      gd_image = gd_image_pointer.value

      width = gd_image.sx
      height = gd_image.sy
      pixels = Array.new(height) { Array.new(width, 0u32) }

      height.times do |y|
        width.times do |x|
          pixels[y][x] = LibGD.image_get_pixel(gd_image_pointer, x, y).to_u32 << 8
        end
      end

      LibGD.image_destroy(gd_image_pointer)

      new(pixels, width, height, Type::RGB)
    end
  end

  def to_jpeg(quality : Int32 = 100) : String
    image_pointer = LibGD.image_create_true_color(@width, @height)

    @height.times do |y|
      @width.times do |x|
        pixel = @pixels[y][x] >> 8
        LibGD.image_set_pixel(image_pointer, x, y, pixel)
      end
    end

    jpeg_pointer = LibGD.image_jpeg_ptr(image_pointer, out size, quality)
    jpeg_data = String.new(jpeg_pointer, size)

    LibGD.image_destroy(image_pointer)
    LibGD.free(jpeg_pointer)

    jpeg_data
  end
end

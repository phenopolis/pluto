module Pluto::Format::PPM
  macro included
    def self.from_ppm(image_data : String) : Image
      io = IO::Memory.new(image_data)

      _magic_number = io.gets("\n", chomp: true)
      width = io.gets(" ", chomp: true).try &.to_i
      height = io.gets("\n", chomp: true).try &.to_i
      _maximum_color_value = io.gets("\n", chomp: true)

      if width && height
        pixels = Array(RGBA).new(width * height) { RGBA.new(0, 0, 0, 255) }

        (width * height).times do |index|
          red_byte = io.read_byte
          green_byte = io.read_byte
          blue_byte = io.read_byte
          if red_byte && green_byte && blue_byte
            pixel = RGBA.new(
              red_byte,
              green_byte,
              blue_byte,
              255
            )
            pixels.unsafe_put(index, pixel)
          else
            raise "The image ends prematurely"
          end
        end

        new(pixels, width, height)
      else
        raise "The image doesn't have width or height"
      end
    end
  end

  def to_ppm : String
    String.build do |string|
      string << "P6\n"
      string << @width << " " << @height << "\n"
      string << "255\n"
      @pixels.each do |pixel|
        string.write_byte(pixel.red)
        string.write_byte(pixel.green)
        string.write_byte(pixel.blue)
      end
    end
  end
end

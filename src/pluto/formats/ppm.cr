require "../image"

module Pluto::Formats::PPM
  macro included
    def self.from_ppm(image_data : String) : Image
      io = IO::Memory.new(image_data)

      _magic_number = io.gets("\n", chomp: true)
      width = io.gets(" ", chomp: true).try &.to_i
      height = io.gets("\n", chomp: true).try &.to_i
      _maximum_color_value = io.gets("\n", chomp: true)

      if width && height
        red = Array.new(height) { Array.new(width, 0u8) }
        green = Array.new(height) { Array.new(width, 0u8) }
        blue = Array.new(height) { Array.new(width, 0u8) }
        alpha = Array.new(height) { Array.new(width, 0u8) }

        height.times do |y|
          width.times do |x|
            red_byte = io.read_byte
            green_byte = io.read_byte
            blue_byte = io.read_byte
            if red_byte && green_byte && blue_byte
              red[y][x] = red_byte
              green[y][x] = green_byte
              blue[y][x] = blue_byte
            else
              raise "The image ends prematurely"
            end
          end
        end

        new(red, green, blue, alpha, width, height)
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
      @height.times do |y|
        @width.times do |x|
          string.write_byte(@red[y][x])
          string.write_byte(@green[y][x])
          string.write_byte(@blue[y][x])
        end
      end
    end
  end
end

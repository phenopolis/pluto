module Pluto::Format::PPM
  macro included
    def self.from_ppm(image_data : String) : Image
      io = IO::Memory.new(image_data)

      _magic_number = io.gets("\n", chomp: true)
      width = io.gets(" ", chomp: true).try &.to_i
      height = io.gets("\n", chomp: true).try &.to_i
      _maximum_color_value = io.gets("\n", chomp: true)

      if width && height
        red = Array.new(width * height) { 0u8 }
        green = Array.new(width * height) { 0u8 }
        blue = Array.new(width * height) { 0u8 }
        alpha = Array.new(width * height) { 0u8 }

        (width * height).times do |index|
          red_byte = io.read_byte
          green_byte = io.read_byte
          blue_byte = io.read_byte
          if red_byte && green_byte && blue_byte
            red[index] = red_byte
            green[index] = green_byte
            blue[index] = blue_byte
          else
            raise "The image ends prematurely"
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
      (@width * @height).times do |index|
        string.write_byte(@red[index])
        string.write_byte(@green[index])
        string.write_byte(@blue[index])
      end
    end
  end
end

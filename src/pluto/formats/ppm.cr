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
        pixels = Array.new(height) { Array.new(width, 0u32) }

        height.times do |y|
          width.times do |x|
            red = io.read_byte.try &.to_u32
            green = io.read_byte.try &.to_u32
            blue = io.read_byte.try &.to_u32
            if red && green && blue
              pixels[y][x] = red << 24 | green << 16 | blue << 8
            else
              raise "The image ends prematurely"
            end
          end
        end

        new(pixels, width, height, Type::RGB)
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
          pixel = @pixels[y][x]
          red = ((pixel & 0xFF000000) >> 24).to_u8
          green = ((pixel & 0x00FF0000) >> 16).to_u8
          blue = ((pixel & 0x0000FF00) >> 8).to_u8
          string.write_byte(red)
          string.write_byte(green)
          string.write_byte(blue)
        end
      end
    end
  end
end

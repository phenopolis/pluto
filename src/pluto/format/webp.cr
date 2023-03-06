module Pluto::Format::WebP
  macro included
    # This is the preferred, most performant WebP overload with the least memory consumption.
    def self.from_webp(image_data : Bytes) : self
      check_webp LibWebP.get_info(image_data, image_data.size, out width, out height)
      buffer = LibWebP.decode_rgba(
        image_data,
        image_data.size,
        pointerof(width),
        pointerof(height)
      )

      red = Array.new(width * height) { 0u8 }
      green = Array.new(width * height) { 0u8 }
      blue = Array.new(width * height) { 0u8 }
      alpha = Array.new(width * height) { 0u8 }

      (width * height).times do |index|
        red.unsafe_put(index, buffer[index * 4])
        green.unsafe_put(index, buffer[index * 4 + 1])
        blue.unsafe_put(index, buffer[index * 4 + 2])
        alpha.unsafe_put(index, buffer[index * 4 + 3])
      end

      LibWebP.free(buffer)

      new(red, green, blue, alpha, width, height)
    end

    # This is a less preferred WebP overload.
    def self.from_webp(io : IO) : self
      from_webp(io.getb_to_end)
    end

    protected def self.check_webp(code)
      raise ::Pluto::Exception.new(code) if code == 0
    end
  end

  def to_webp(io : IO) : Nil
    image_data = String.build do |string|
      size.times do |index|
        string.write_byte(red.unsafe_fetch(index))
        string.write_byte(green.unsafe_fetch(index))
        string.write_byte(blue.unsafe_fetch(index))
        string.write_byte(alpha.unsafe_fetch(index))
      end
    end

    size = LibWebP.encode_lossless_rgba(
      image_data,
      @width,
      @height,
      @width * 4,
      out buffer
    )
    check_webp size

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    LibWebP.free(buffer)
  end

  private def check_webp(code)
    self.class.check_webp(code.to_i)
  end
end

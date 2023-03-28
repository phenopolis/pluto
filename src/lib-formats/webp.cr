require "./bindings/lib_webp"

module Pluto::Format::WebP
  macro included
    # This is the preferred, most performant WebP overload with the least memory consumption.
    def self.from_webp(image_data : Bytes) : self
      check_webp PlutoLibWebP.get_info(image_data, image_data.size, out width, out height)
      buffer = PlutoLibWebP.decode_rgba(
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
        position = index * 4
        red.unsafe_put(index, buffer[position + 0])
        green.unsafe_put(index, buffer[position + 1])
        blue.unsafe_put(index, buffer[position + 2])
        alpha.unsafe_put(index, buffer[position + 3])
      end

      PlutoLibWebP.free(buffer)

      new(red, green, blue, alpha, width, height)
    end

    # This is a less preferred WebP overload.
    def self.from_webp(io : IO) : self
      from_webp(io.getb_to_end)
    end

    protected def self.check_webp(code)
      raise ::Pluto::Exception.new(code.to_i) if code == 0
    end
  end

  def to_lossless_webp(io : IO) : Nil
    image_data = IO::Memory.new(size * 4)
    size.times do |index|
      image_data.write_byte(red.unsafe_fetch(index))
      image_data.write_byte(green.unsafe_fetch(index))
      image_data.write_byte(blue.unsafe_fetch(index))
      image_data.write_byte(alpha.unsafe_fetch(index))
    end

    size = PlutoLibWebP.encode_lossless_rgba(
      image_data.buffer,
      @width,
      @height,
      @width * 4,
      out buffer
    )
    check_webp size

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    PlutoLibWebP.free(buffer)
  end

  def to_lossy_webp(io : IO, quality : Int32 = 100) : Nil
    image_data = IO::Memory.new(size * 4)
    size.times do |index|
      image_data.write_byte(red.unsafe_fetch(index))
      image_data.write_byte(green.unsafe_fetch(index))
      image_data.write_byte(blue.unsafe_fetch(index))
      image_data.write_byte(alpha.unsafe_fetch(index))
    end

    size = PlutoLibWebP.encode_rgba(
      image_data.buffer,
      @width,
      @height,
      @width * 4,
      quality,
      out buffer
    )
    check_webp size

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    PlutoLibWebP.free(buffer)
  end

  delegate check_webp, to: self.class
end

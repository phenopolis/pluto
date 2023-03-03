module Pluto::Format::JPEG
  macro included
    # This is the preferred, most performant JPEG overload with the least memory consumption.
    def self.from_jpeg(image_data : Bytes) : self
      handle = LibJPEGTurbo.init_decompress
      check handle, LibJPEGTurbo.decompress_header3(
        handle,
        image_data,
        image_data.size,
        out width,
        out height,
        out _subsampling,
        out _colorspace
      )
      buffer = Bytes.new(width * height * 3, 0)
      check handle, LibJPEGTurbo.decompress2(
        handle,
        image_data,
        LibC::ULong.new(image_data.size),
        buffer,
        width,
        0,
        height,
        LibJPEGTurbo::PixelFormat::RGB,
        0
      )
      check handle, LibJPEGTurbo.destroy(handle)

      red = Array.new(width * height) { 0u8 }
      green = Array.new(width * height) { 0u8 }
      blue = Array.new(width * height) { 0u8 }
      alpha = Array.new(width * height) { 255u8 }

      (width * height).times do |index|
        red.unsafe_put(index, buffer[index * 3])
        green.unsafe_put(index, buffer[index * 3 + 1])
        blue.unsafe_put(index, buffer[index * 3 + 2])
      end

      new(red, green, blue, alpha, width, height)
    end

    # This is a less preferred JPEG overload.
    def self.from_jpeg(io : IO) : self
      from_jpeg(io.getb_to_end)
    end

    private def self.check(handle, code)
      raise ::Pluto::Exception.new(handle) unless code == 0
    end
  end

  def to_jpeg(io : IO, quality : Int32 = 100) : Nil
    handle = LibJPEGTurbo.init_compress
    image_data = IO::Memory.new(size * 3)
    size.times do |index|
      image_data.write_byte(red.unsafe_fetch(index))
      image_data.write_byte(green.unsafe_fetch(index))
      image_data.write_byte(blue.unsafe_fetch(index))
    end

    buffer = Pointer(UInt8).null
    check handle, LibJPEGTurbo.compress2(
      handle,
      image_data.buffer,
      @width,
      0,
      @height,
      LibJPEGTurbo::PixelFormat::RGB,
      pointerof(buffer),
      out size,
      LibJPEGTurbo::Subsampling::S444,
      quality,
      0
    )
    check handle, LibJPEGTurbo.destroy(handle)

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    LibJPEGTurbo.free(buffer)
  end

  private def check(handle, code)
    raise ::Pluto::Exception.new(handle) unless code == 0
  end
end

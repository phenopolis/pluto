module Pluto::Format::JPEG
  macro included
    def self.from_jpeg(io : IO) : self
      image_data = io.getb_to_end

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
      pixels = buffer.each_slice(3).to_a

      (width * height).times do |index|
        red.unsafe_put(index, pixels.unsafe_fetch(index).unsafe_fetch(0))
        green.unsafe_put(index, pixels.unsafe_fetch(index).unsafe_fetch(1))
        blue.unsafe_put(index, pixels.unsafe_fetch(index).unsafe_fetch(2))
      end

      new(red, green, blue, alpha, width, height)
    end

    def self.from_jpeg(image_data : String) : self
      io = IO::Memory.new(image_data)
      from_jpeg(io)
    end

    private def self.check(handle, code)
      raise ::Pluto::Exception.new(handle) unless code == 0
    end
  end

  def to_jpeg(io : IO, quality : Int32 = 100) : Nil
    buf, size = buffer(quality)
    io.write(Slice(UInt8).new(buf, size))
  end

  def to_jpeg(quality : Int32 = 100) : String
    buf, size = buffer(quality)
    String.new(buf, size)
  end

  private def buffer(quality : Int32 = 100) : Tuple(Pointer(UInt8), UInt64)
    handle = LibJPEGTurbo.init_compress
    image_data = String.build do |string|
      size.times do |index|
        string.write_byte(red.unsafe_fetch(index))
        string.write_byte(green.unsafe_fetch(index))
        string.write_byte(blue.unsafe_fetch(index))
      end
    end

    buffer = Array(UInt8).new.to_unsafe
    check handle, LibJPEGTurbo.compress2(
      handle,
      image_data,
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

    {buffer, size}
  end

  private def check(handle, code)
    raise ::Pluto::Exception.new(handle) unless code == 0
  end
end

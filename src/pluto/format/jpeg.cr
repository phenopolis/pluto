module Pluto::Format::JPEG
  macro included
    def self.open_jpeg(filename : String) : self
      from_jpeg(File.read(filename))
    end

    def self.from_jpeg(image_data : String) : self
      handle = LibJPEGTurbo.init_decompress
      LibJPEGTurbo.decompress_header3(
        handle,
        image_data,
        image_data.bytesize,
        out width,
        out height,
        out _subsampling,
        out _colorspace
      )
      buffer = Bytes.new(width * height * 3, 0)
      LibJPEGTurbo.decompress2(
        handle,
        image_data,
        LibC::ULong.new(image_data.bytesize),
        buffer,
        width,
        0,
        height,
        LibJPEGTurbo::PixelFormat::RGB,
        0
      )
      LibJPEGTurbo.destroy(handle)

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
  end

  def to_jpeg(filename : String, quality : Int32 = 100) : Nil
    File.open(filename, "w") { |f| to_jpeg(f, quality) }
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
    LibJPEGTurbo.compress2(
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
    LibJPEGTurbo.destroy(handle)

    {buffer, size}
  end
end

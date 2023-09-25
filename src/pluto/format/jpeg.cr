require "./binding/lib_jpeg_turbo"

module Pluto::Format::JPEG
  macro included
    def self.from_jpeg(image_data : Bytes) : self
      handle = Format::Binding::LibJPEGTurbo.init_decompress
      check_jpeg handle, Format::Binding::LibJPEGTurbo.decompress_header3(
        handle,
        image_data,
        image_data.size,
        out width,
        out height,
        out _subsampling,
        out _colorspace
      )
      buffer = Bytes.new(width * height * 3, 0)
      check_jpeg handle, Format::Binding::LibJPEGTurbo.decompress2(
        handle,
        image_data,
        LibC::ULong.new(image_data.size),
        buffer,
        width,
        0,
        height,
        Format::Binding::LibJPEGTurbo::PixelFormat::RGB,
        0
      )
      Format::Binding::LibJPEGTurbo.destroy(handle)

      red = Array.new(width * height) { 0u8 }
      green = Array.new(width * height) { 0u8 }
      blue = Array.new(width * height) { 0u8 }
      alpha = Array.new(width * height) { 255u8 }

      (width * height).times do |index|
        position = index * 3
        red.unsafe_put(index, buffer[position + 0])
        green.unsafe_put(index, buffer[position + 1])
        blue.unsafe_put(index, buffer[position + 2])
      end

      new(red, green, blue, alpha, width, height)
    end

    def self.from_jpeg(io : IO) : self
      from_jpeg(io.getb_to_end)
    end

    protected def self.check_jpeg(handle, code)
      message = String.new(Format::Binding::LibJPEGTurbo.get_error_str(handle))
      error_code = Format::Binding::LibJPEGTurbo.get_error_code(handle).to_i

      raise ::Pluto::Exception.new(message, error_code) unless code == 0
    end
  end

  def to_jpeg(io : IO, quality : Int32 = 100) : Nil
    handle = Format::Binding::LibJPEGTurbo.init_compress
    image_data = IO::Memory.new(size * 3)
    size.times do |index|
      image_data.write_byte(red.unsafe_fetch(index))
      image_data.write_byte(green.unsafe_fetch(index))
      image_data.write_byte(blue.unsafe_fetch(index))
    end

    buffer = Pointer(UInt8).null
    check_jpeg handle, Format::Binding::LibJPEGTurbo.compress2(
      handle,
      image_data.buffer,
      @width,
      0,
      @height,
      Format::Binding::LibJPEGTurbo::PixelFormat::RGB,
      pointerof(buffer),
      out size,
      Format::Binding::LibJPEGTurbo::Subsampling::S444,
      quality,
      0
    )
    Format::Binding::LibJPEGTurbo.destroy(handle)

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    Format::Binding::LibJPEGTurbo.free(buffer)
  end

  @[Deprecated("The visibility of this method will be changing in the future, and it should not be used directly.")]
  # :nodoc:
  delegate check_jpeg, to: self.class
end

{% for subclass in Pluto::Image.subclasses %}
  class {{subclass}}
    include Pluto::Format::JPEG
  end
{% end %}

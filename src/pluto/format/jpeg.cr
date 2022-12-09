module Pluto::Format::JPEG
  macro included
    def self.from_jpeg(image_data : String) : Image
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

      pixels = buffer.each_slice(3).to_a.map do |pixel|
        RGBA.new(pixel.unsafe_fetch(0), pixel.unsafe_fetch(1), pixel.unsafe_fetch(2), 255)
      end

      new(pixels, width, height)
    end
  end

  def to_jpeg(quality : Int32 = 100) : String
    handle = LibJPEGTurbo.init_compress
    image_data = String.build do |string|
      (@width * @height).times do |index|
        string.write_byte(@pixels.unsafe_fetch(index).red)
        string.write_byte(@pixels.unsafe_fetch(index).green)
        string.write_byte(@pixels.unsafe_fetch(index).blue)
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

    String.new(buffer, size)
  end
end

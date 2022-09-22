require "./bindings/lib_jpeg_turbo"

module Pluto::Formats::JPEG
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

      red = Array.new(height) { Array.new(width, 0u8) }
      green = Array.new(height) { Array.new(width, 0u8) }
      blue = Array.new(height) { Array.new(width, 0u8) }
      alpha = Array.new(height) { Array.new(width, 0u8) }
      pixels = buffer.each_slice(3).each_slice(width).to_a

      height.times do |y|
        width.times do |x|
          red[y][x] = pixels[y][x][0]
          green[y][x] = pixels[y][x][1]
          blue[y][x] = pixels[y][x][2]
        end
      end

      new(red, green, blue, alpha, width, height)
    end
  end

  def to_jpeg(quality : Int32 = 100) : String
    handle = LibJPEGTurbo.init_compress
    image_data = String.build do |string|
      @height.times do |y|
        @width.times do |x|
          string.write_byte(@red[y][x])
          string.write_byte(@green[y][x])
          string.write_byte(@blue[y][x])
        end
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

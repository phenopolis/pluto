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
        out subsampling,
        out colorspace
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

      pixels = buffer.each_slice(3).map do |pixel|
        red = pixel[0].to_u32 << 24
        green = pixel[1].to_u32 << 16
        blue = pixel[2].to_u32 << 8
        red | green | blue
      end.each_slice(width).to_a

      new(pixels, width, height)
    end
  end

  def to_jpeg(quality : Int32 = 100) : String
    handle = LibJPEGTurbo.init_compress
    image_data = String.build do |string|
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

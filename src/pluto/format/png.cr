require "./binding/lib_spng"

module Pluto::Format::PNG
  macro included
    # This is the preferred, most performant PNG overload with the least memory consumption.
    def self.from_png(image_data : Bytes) : self
      ctx = PlutoLibSPNG.ctx_new(PlutoLibSPNG::CtxFlags::None)
      raise ::Pluto::Exception.new("Failed to create a context") unless ctx

      PlutoLibSPNG.set_png_buffer(ctx, image_data, image_data.size)

      check_png PlutoLibSPNG.get_ihdr(ctx, out ihdr)
      check_png PlutoLibSPNG.decoded_image_size(ctx, PlutoLibSPNG::Format::RGBA8, out image_size)

      image = Bytes.new(image_size.to_i, 0u8)
      check_png PlutoLibSPNG.decode_image(
        ctx,
        image,
        image_size,
        PlutoLibSPNG::Format::RGBA8,
        PlutoLibSPNG::DecodeFlags::None
      )

      PlutoLibSPNG.ctx_free(ctx)

      size = image_size // 4
      width = size // ihdr.height
      height = ihdr.height

      red = Array.new(size) { 0u8 }
      green = Array.new(size) { 0u8 }
      blue = Array.new(size) { 0u8 }
      alpha = Array.new(size) { 0u8 }

      size.times do |index|
        position = index * 4
        red.unsafe_put(index, image[position + 0])
        green.unsafe_put(index, image[position + 1])
        blue.unsafe_put(index, image[position + 2])
        alpha.unsafe_put(index, image[position + 3])
      end

      new(red, green, blue, alpha, width.to_i, height.to_i)
    end

    # This is a less preferred PNG overload.
    def self.from_png(io : IO) : self
      from_png(io.getb_to_end)
    end

    protected def self.check_png(code)
      raise ::Pluto::Exception.new(code) if code != 0
    end
  end

  def to_png(io : IO) : Nil
    image_data = IO::Memory.new(size * 4)
    size.times do |index|
      image_data.write_byte(red.unsafe_fetch(index))
      image_data.write_byte(green.unsafe_fetch(index))
      image_data.write_byte(blue.unsafe_fetch(index))
      image_data.write_byte(alpha.unsafe_fetch(index))
    end

    ctx = PlutoLibSPNG.ctx_new(PlutoLibSPNG::CtxFlags::Encoder)
    raise ::Pluto::Exception.new("Failed to create a context") unless ctx

    PlutoLibSPNG.set_option(ctx, PlutoLibSPNG::Option::EncodeToBuffer, true)
    PlutoLibSPNG.set_png_buffer(ctx, image_data.buffer, image_data.size)

    ihdr = PlutoLibSPNG::IHDR.new
    ihdr.width = @width
    ihdr.height = @height
    ihdr.color_type = PlutoLibSPNG::ColorType::TrueColorAlpha
    ihdr.bit_depth = 8
    PlutoLibSPNG.set_ihdr(ctx, pointerof(ihdr))

    error = PlutoLibSPNG.encode_image(
      ctx,
      image_data.buffer,
      image_data.size,
      PlutoLibSPNG::Format::PNG,
      PlutoLibSPNG::EncodeFlags::Finalize
    )
    check_png error

    buffer = PlutoLibSPNG.get_png_buffer(ctx, out size, pointerof(error))
    raise ::Pluto::Exception.new("Failed to get a buffer") unless ctx

    bytes = Bytes.new(buffer, size)
    io.write(bytes)

    LibC.free(buffer)
  end

  delegate check_png, to: self.class
end

{% for subclass in Pluto::Image.subclasses %}
  class {{subclass}}
    include Pluto::Format::PNG
  end
{% end %}

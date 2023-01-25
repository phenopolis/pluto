module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : Image
    clone.vertical_blur!(value)
  end

  def vertical_blur!(value : Int32) : Image
    blurred_pixels = Slice.new(@width * @height) { RGBA.new(0, 0, 0, 255) }
    multiplier = 1 / (value + value + 1)

    @width.times do |x|
      c_index : Int32 = x
      l_index : Int32 = c_index
      r_index : Int32 = c_index + value * @width

      f_pixel = @pixels.unsafe_fetch(c_index)
      l_pixel = @pixels.unsafe_fetch(c_index + @width * (@height - 1))

      r_sum : Int32 = (value + 1) * f_pixel.red
      g_sum : Int32 = (value + 1) * f_pixel.green
      b_sum : Int32 = (value + 1) * f_pixel.blue

      (0..value - 1).each do
        pixel = @pixels.unsafe_fetch(c_index)
        r_sum += pixel.red
        g_sum += pixel.green
        b_sum += pixel.blue
      end

      (0..value).each do
        pixel = @pixels.unsafe_fetch(r_index)
        r_sum += pixel.red.to_i - f_pixel.red
        g_sum += pixel.green.to_i - f_pixel.green
        b_sum += pixel.blue.to_i - f_pixel.blue

        blurred_pixel = RGBA.new(
          (r_sum * multiplier).to_u8,
          (g_sum * multiplier).to_u8,
          (b_sum * multiplier).to_u8,
          255
        )
        blurred_pixels.unsafe_put(c_index, blurred_pixel)

        r_index += @width
        c_index += @width
      end

      (value + 1..@height - value - 1).each do
        r_index_pixel = @pixels.unsafe_fetch(r_index)
        l_index_pixel = @pixels.unsafe_fetch(l_index)
        r_sum += r_index_pixel.red.to_i - l_index_pixel.red
        g_sum += r_index_pixel.green.to_i - l_index_pixel.green
        b_sum += r_index_pixel.blue.to_i - l_index_pixel.blue

        blurred_pixel = RGBA.new(
          (r_sum * multiplier).to_u8,
          (g_sum * multiplier).to_u8,
          (b_sum * multiplier).to_u8,
          255
        )
        blurred_pixels.unsafe_put(c_index, blurred_pixel)

        l_index += @width
        r_index += @width
        c_index += @width
      end

      (@height - value..@height - 1).each do
        pixel = @pixels.unsafe_fetch(l_index)
        r_sum += l_pixel.red.to_i - pixel.red
        g_sum += l_pixel.green.to_i - pixel.green
        b_sum += l_pixel.blue.to_i - pixel.blue

        blurred_pixel = RGBA.new(
          (r_sum * multiplier).to_u8,
          (g_sum * multiplier).to_u8,
          (b_sum * multiplier).to_u8,
          255
        )
        blurred_pixels.unsafe_put(c_index, blurred_pixel)

        l_index += @width
        c_index += @width
      end
    end

    @pixels.@buffer.copy_from(blurred_pixels.to_unsafe, @width * @height)

    self
  end
end

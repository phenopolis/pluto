module Pluto::Operation::BilinearResize
  def bilinear_resize(width : Int32, height : Int32) : Image
    clone.bilinear_resize!(width, height)
  end

  def bilinear_resize!(width : Int32, height : Int32) : Image
    resized_pixels = Array.new(width * height) { RGBA.new(0, 0, 0, 255) }

    x_ratio = width > 1 ? (@width - 1) / (width - 1) : 0
    y_ratio = height > 1 ? (@height - 1) / (height - 1) : 0

    height.times do |h|
      width.times do |w|
        x = w * x_ratio
        y = h * y_ratio

        x_ceil = Math.min(@width - 1, x.ceil.to_i)
        x_floor = x.floor.to_i
        y_ceil = Math.min(@height - 1, y.ceil.to_i)
        y_floor = y.floor.to_i

        resized_pixel =
          case
          when x_ceil == x_floor && y_ceil == y_floor
            x_index = x.to_i
            y_index = y.to_i
            @pixels.unsafe_fetch(@width * y_index + x_index)
          when x_ceil == x_floor
            x_index = x.to_i
            pixel_q_1 = @pixels.unsafe_fetch(@width * y_ceil + x_index)
            pixel_q_2 = @pixels.unsafe_fetch(@width * y_floor + x_index)
            RGBA.new(
              (pixel_q_2.red * (y_ceil - y) + pixel_q_1.red * (y - y_floor)).to_u8,
              (pixel_q_2.green * (y_ceil - y) + pixel_q_1.green * (y - y_floor)).to_u8,
              (pixel_q_2.blue * (y_ceil - y) + pixel_q_1.blue * (y - y_floor)).to_u8,
              255
            )
          when y_ceil == y_floor
            y_index = y.to_i
            pixel_q_1 = @pixels.unsafe_fetch(@width * y_index + x_ceil)
            pixel_q_2 = @pixels.unsafe_fetch(@width * y_index + x_floor)
            RGBA.new(
              (pixel_q_2.red * (x_ceil - x) + pixel_q_1.red * (x - x_floor)).to_u8,
              (pixel_q_2.green * (x_ceil - x) + pixel_q_1.green * (x - x_floor)).to_u8,
              (pixel_q_2.blue * (x_ceil - x) + pixel_q_1.blue * (x - x_floor)).to_u8,
              255
            )
          else
            pixel_v_1 = @pixels.unsafe_fetch(@width * y_floor + x_floor)
            pixel_v_2 = @pixels.unsafe_fetch(@width * y_floor + x_ceil)
            pixel_v_3 = @pixels.unsafe_fetch(@width * y_ceil + x_floor)
            pixel_v_4 = @pixels.unsafe_fetch(@width * y_ceil + x_ceil)
            red_q_1 = pixel_v_1.red * (x_ceil - x) + pixel_v_2.red * (x - x_floor)
            red_q_2 = pixel_v_3.red * (x_ceil - x) + pixel_v_4.red * (x - x_floor)
            green_q_1 = pixel_v_1.green * (x_ceil - x) + pixel_v_2.green * (x - x_floor)
            green_q_2 = pixel_v_3.green * (x_ceil - x) + pixel_v_4.green * (x - x_floor)
            blue_q_1 = pixel_v_1.blue * (x_ceil - x) + pixel_v_2.blue * (x - x_floor)
            blue_q_2 = pixel_v_3.blue * (x_ceil - x) + pixel_v_4.blue * (x - x_floor)
            RGBA.new(
              (red_q_1 * (y_ceil - y) + red_q_2 * (y - y_floor)).to_u8,
              (green_q_1 * (y_ceil - y) + green_q_2 * (y - y_floor)).to_u8,
              (blue_q_1 * (y_ceil - y) + blue_q_2 * (y - y_floor)).to_u8,
              255
            )
          end

        resized_pixels.unsafe_put(width * h + w, resized_pixel)
      end
    end

    @pixels = resized_pixels
    @width = width
    @height = height

    self
  end
end

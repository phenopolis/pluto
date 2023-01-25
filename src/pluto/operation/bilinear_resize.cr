module Pluto::Operation::BilinearResize
  def bilinear_resize(width : Int32, height : Int32) : Image
    clone.bilinear_resize!(width, height)
  end

  def bilinear_resize!(width : Int32, height : Int32) : Image
    channels = {@red, @green, @blue, @alpha}
    resized_channels = [] of Array(UInt8)

    x_ratio = width > 1 ? (@width - 1) / (width - 1) : 0
    y_ratio = height > 1 ? (@height - 1) / (height - 1) : 0

    channels.each do |channel|
      resized_channel = Array.new(width * height) { 0u8 }

      height.times do |h|
        width.times do |w|
          x = w * x_ratio
          y = h * y_ratio

          x_ceil = Math.min(@width - 1, x.ceil.to_i)
          x_floor = x.floor.to_i
          y_ceil = Math.min(@height - 1, y.ceil.to_i)
          y_floor = y.floor.to_i

          value =
            case
            when x_ceil == x_floor && y_ceil == y_floor
              x_index = x.to_i
              y_index = y.to_i
              channel.unsafe_fetch(@width * y_index + x_index)
            when x_ceil == x_floor
              x_index = x.to_i
              q_1 = channel.unsafe_fetch(@width * y_ceil + x_index)
              q_2 = channel.unsafe_fetch(@width * y_floor + x_index)
              (q_2 * (y_ceil - y) + q_1 * (y - y_floor)).to_u8
            when y_ceil == y_floor
              y_index = y.to_i
              q_1 = channel.unsafe_fetch(@width * y_index + x_ceil)
              q_2 = channel.unsafe_fetch(@width * y_index + x_floor)
              (q_2 * (x_ceil - x) + q_1 * (x - x_floor)).to_u8
            else
              v_1 = channel.unsafe_fetch(@width * y_floor + x_floor)
              v_2 = channel.unsafe_fetch(@width * y_floor + x_ceil)
              v_3 = channel.unsafe_fetch(@width * y_ceil + x_floor)
              v_4 = channel.unsafe_fetch(@width * y_ceil + x_ceil)
              q_1 = v_1 * (x_ceil - x) + v_2 * (x - x_floor)
              q_2 = v_3 * (x_ceil - x) + v_4 * (x - x_floor)
              (q_1 * (y_ceil - y) + q_2 * (y - y_floor)).to_u8
            end

          resized_channel.unsafe_put(width * h + w, value)
        end
      end

      resized_channels << resized_channel
    end

    @red = resized_channels.unsafe_fetch(0)
    @green = resized_channels.unsafe_fetch(1)
    @blue = resized_channels.unsafe_fetch(2)
    @alpha = resized_channels.unsafe_fetch(3)
    @width = width
    @height = height

    self
  end
end

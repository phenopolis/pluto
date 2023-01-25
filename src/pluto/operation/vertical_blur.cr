module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : Image
    clone.vertical_blur!(value)
  end

  def vertical_blur!(value : Int32) : Image
    channels = {@red, @green, @blue, @alpha}

    buffer = Bytes.new(size, 0)
    multiplier = 1 / (value + value + 1)

    channels.each do |channel|
      @width.times do |x|
        c_index : Int32 = x
        l_index : Int32 = c_index
        r_index : Int32 = c_index + value * @width

        f_value : Int32 = channel.unsafe_fetch(c_index).to_i32
        l_value : Int32 = channel.unsafe_fetch(c_index + @width * (@height - 1)).to_i32
        c_value : Int32 = (value + 1) * f_value

        (0..value - 1).each do
          c_value += channel.unsafe_fetch(c_index)
        end

        (0..value).each do
          c_value += channel.unsafe_fetch(r_index).to_i32 - f_value
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          r_index += @width
          c_index += @width
        end

        (value + 1..@height - value - 1).each do
          c_value += channel.unsafe_fetch(r_index).to_i32 - channel.unsafe_fetch(l_index).to_i32
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          l_index += @width
          r_index += @width
          c_index += @width
        end

        (@height - value..@height - 1).each do
          c_value += l_value - channel.unsafe_fetch(l_index).to_i32
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          l_index += @width
          c_index += @width
        end
      end

      channel.@buffer.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

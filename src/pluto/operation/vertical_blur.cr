module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : Image
    clone.vertical_blur!(value)
  end

  def vertical_blur!(value : Int32) : Image
    channels = {@red, @green, @blue, @alpha}

    buffer = Bytes.new(channels[0].size, 0)
    multiplier = 1 / (value + value + 1)

    channels.each do |channel|
      vertical_blur_channel(channel, value, multiplier, buffer)
      channel.@buffer.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end

  private def vertical_blur_channel(channel, value, multiplier, buf)
    @width.times do |x|
      c_i : Int32 = x
      l_i : Int32 = c_i
      r_i : Int32 = c_i + value * @width

      f_v : Int32 = channel.unsafe_fetch(c_i).to_i32
      l_v : Int32 = channel.unsafe_fetch(c_i + @width * (@height - 1)).to_i32
      c_v : Int32 = (value + 1) * f_v

      (0..value - 1).each do |j|
        c_v += channel.unsafe_fetch(c_i + j * @width)
      end

      (0..value).each do
        c_v += channel.unsafe_fetch(r_i).to_i32 - f_v
        buf.unsafe_put(c_i, (c_v * multiplier).to_u8)
        r_i += @width
        c_i += @width
      end

      (value + 1..@height - value - 1).each do
        c_v += channel.unsafe_fetch(r_i).to_i32 - channel.unsafe_fetch(l_i).to_i32
        buf.unsafe_put(c_i, (c_v * multiplier).to_u8)
        l_i += @width
        r_i += @width
        c_i += @width
      end

      (@height - value..@height - 1).each do
        c_v += l_v - channel.unsafe_fetch(l_i).to_i32
        buf.unsafe_put(c_i, (c_v * multiplier).to_u8)
        l_i += @width
        c_i += @width
      end
    end
  end
end

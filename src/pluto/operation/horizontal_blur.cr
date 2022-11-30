module Pluto::Operation::HorizontalBlur
  def horizontal_blur(value : Int32) : Image
    clone.horizontal_blur!(value)
  end

  def horizontal_blur!(value : Int32) : Image
    channels = {@red, @green, @blue, @alpha}

    buffer = Bytes.new(channels[0].size, 0)
    mul = 1 / (value + value + 1)

    channels.each do |channel|
      horizontal_blur_channel(channel, value, mul, buffer)
      channel.@buffer.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end

  private def horizontal_blur_channel(channel, value, mul, buf)
    @height.times do |y|
      c_i : Int32 = y * @width
      l_i : Int32 = c_i
      r_i : Int32 = c_i + value

      f_v : Int32 = channel.unsafe_fetch(c_i).to_i32
      l_v : Int32 = channel.unsafe_fetch(c_i + @width - 1).to_i32
      c_v : Int32 = (value + 1) * f_v

      (0..value - 1).each do |j|
        c_v += channel.unsafe_fetch(c_i + j)
      end
      (0..value).each do
        c_v += channel.unsafe_fetch(r_i).to_i32 - f_v
        r_i += 1
        buf.unsafe_put(c_i, (c_v * mul).round.to_u8)
        c_i += 1
      end
      (value + 1..@width - value - 1).each do
        c_v += (channel.unsafe_fetch(r_i).to_i32 - channel.unsafe_fetch(l_i).to_i32)
        r_i += 1
        l_i += 1
        buf.unsafe_put(c_i, (c_v * mul).round.to_u8)
        c_i += 1
      end
      (@width - value..@width - 1).each do
        c_v += l_v - channel.unsafe_fetch(l_i).to_i32
        l_i += 1
        buf.unsafe_put(c_i, (c_v * mul).round.to_u8)
        c_i += 1
      end
    end
  end
end

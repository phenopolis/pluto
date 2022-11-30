module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : Image
    clone.vertical_blur!(value)
  end

  def vertical_blur!(value : Int32) : Image
    channels = {@red, @green, @blue, @alpha}.map(&.map(&.to_i))
    blurred_channels = [] of Array(UInt8)

    channels.each do |channel|
      blurred_channel = Array.new(channel.size) { 0u8 }
      multiplier = 1 / (value + value + 1)
      @width.times do |x|
        c_i = x
        l_i = c_i
        r_i = c_i + value * @width

        f_v = channel.unsafe_fetch(c_i)
        l_v = channel.unsafe_fetch(c_i + @width * (@height - 1))
        c_v = (value + 1) * f_v

        (0..value - 1).each do |j|
          c_v += channel.unsafe_fetch(c_i + j * @width)
        end
        (0..value).each do
          c_v += channel.unsafe_fetch(r_i) - f_v
          blurred_channel.unsafe_put(c_i, (c_v * multiplier).round.to_u8)
          r_i += @width
          c_i += @width
        end
        (value + 1..@height - value - 1).each do
          c_v += channel.unsafe_fetch(r_i) - channel.unsafe_fetch(l_i)
          blurred_channel.unsafe_put(c_i, (c_v * multiplier).round.to_u8)
          l_i += @width
          r_i += @width
          c_i += @width
        end
        (@height - value..@height - 1).each do
          c_v += l_v - channel.unsafe_fetch(l_i)
          blurred_channel.unsafe_put(c_i, (c_v * multiplier).round.to_u8)
          l_i += @width
          c_i += @width
        end
      end
      blurred_channels << blurred_channel
    end

    @red = blurred_channels.unsafe_fetch(0).to_a
    @green = blurred_channels.unsafe_fetch(1).to_a
    @blue = blurred_channels.unsafe_fetch(2).to_a
    @alpha = blurred_channels.unsafe_fetch(3).to_a

    self
  end
end

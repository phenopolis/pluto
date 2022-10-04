module Pluto::Operation::HorizontalBlur
  def horizontal_blur(value : Int32) : Image
    clone.horizontal_blur!(value)
  end

  def horizontal_blur!(value : Int32) : Image
    channels = [@red, @green, @blue, @alpha].map(&.map(&.to_i))
    blurred_channels = [] of Array(UInt8)

    channels.each do |channel|
      blurred_channel = Array.new(channel.size) { 0u8 }
      multiplier = 1 / (value + value + 1)
      @height.times do |y|
        c_i = y * @width
        l_i = c_i
        r_i = c_i + value

        f_v = channel[c_i]
        l_v = channel[c_i + @width - 1]
        c_v = (value + 1) * f_v

        (0..value - 1).each do |j|
          c_v += channel[c_i + j]
        end
        (0..value).each do
          c_v += channel[r_i] - f_v
          r_i += 1
          blurred_channel[c_i] = (c_v * multiplier).round.to_u8
          c_i += 1
        end
        (value + 1..@width - value - 1).each do
          c_v += channel[r_i] - channel[l_i]
          r_i += 1
          l_i += 1
          blurred_channel[c_i] = (c_v * multiplier).round.to_u8
          c_i += 1
        end
        (@width - value..@width - 1).each do
          c_v += l_v - channel[l_i]
          l_i += 1
          blurred_channel[c_i] = (c_v * multiplier).round.to_u8
          c_i += 1
        end
      end
      blurred_channels << blurred_channel
    end

    @red = blurred_channels[0]
    @green = blurred_channels[1]
    @blue = blurred_channels[2]
    @alpha = blurred_channels[3]

    self
  end
end

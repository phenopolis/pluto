module Pluto::Operation::HorizontalBlur
  def horizontal_blur(value : Int32) : self
    clone.horizontal_blur!(value)
  end

  def horizontal_blur!(value : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (value + value + 1)

    each_channel do |channel|
      @height.times do |y|
        c_index : Int32 = y * @width
        l_index : Int32 = c_index
        r_index : Int32 = c_index + value

        f_value : Int32 = channel.unsafe_fetch(c_index).to_i
        l_value : Int32 = channel.unsafe_fetch(c_index + @width - 1).to_i
        c_value : Int32 = (value + 1) * f_value

        (0..value - 1).each do
          c_value += channel.unsafe_fetch(c_index)
        end

        (0..value).each do
          c_value += channel.unsafe_fetch(r_index).to_i - f_value
          buffer.unsafe_put(c_index, (c_value * multiplier).clamp(0, 255).to_u8)

          r_index += 1
          c_index += 1
        end

        (value + 1..@width - value - 1).each do
          c_value += (channel.unsafe_fetch(r_index).to_i - channel.unsafe_fetch(l_index).to_i)
          buffer.unsafe_put(c_index, (c_value * multiplier).clamp(0, 255).to_u8)

          r_index += 1
          l_index += 1
          c_index += 1
        end

        (@width - value..@width - 1).each do
          c_value += l_value - channel.unsafe_fetch(l_index).to_i
          buffer.unsafe_put(c_index, (c_value * multiplier).clamp(0, 255).to_u8)

          l_index += 1
          c_index += 1
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

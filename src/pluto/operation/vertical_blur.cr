module Pluto::Operation::VerticalBlur
  def vertical_blur(k : Int32) : self
    clone.vertical_blur!(k)
  end

  # Blur each column of the image using a sliding window that's `2k + 1` tall
  def vertical_blur!(k : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (k + k + 1)

    each_channel do |channel|
      @width.times do |x|
        col__offset : Int32 = x
        upper_bound : Int32 = col__offset
        lower_bound : Int32 = col__offset + k * @width

        value_at_top : Int32 = channel.unsafe_fetch(col__offset).to_i
        value_at_bottom : Int32 = channel.unsafe_fetch(col__offset + @width * (@height - 1)).to_i
        current_sum : Int32 = (k + 1) * value_at_top

        (0..k - 1).each do |i|
          current_sum += channel.unsafe_fetch(col__offset + i * @width)
        end

        (0..k).each do
          current_sum += channel.unsafe_fetch(lower_bound).to_i - value_at_top
          buffer.unsafe_put(col__offset, (current_sum * multiplier).to_u8)

          lower_bound += @width
          col__offset += @width
        end

        (k + 1..@height - k - 1).each do
          current_sum += channel.unsafe_fetch(lower_bound).to_i - channel.unsafe_fetch(upper_bound).to_i
          buffer.unsafe_put(col__offset, (current_sum * multiplier).to_u8)

          upper_bound += @width
          lower_bound += @width
          col__offset += @width
        end

        (@height - k..@height - 1).each do
          current_sum += value_at_bottom - channel.unsafe_fetch(upper_bound).to_i
          buffer.unsafe_put(col__offset, (current_sum * multiplier).to_u8)

          upper_bound += @width
          col__offset += @width
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

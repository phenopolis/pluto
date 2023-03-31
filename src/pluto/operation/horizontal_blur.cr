module Pluto::Operation::HorizontalBlur
  def horizontal_blur(k : Int32) : self
    clone.horizontal_blur!(k)
  end

  # Blur each row of the image using a sliding window that's `2k + 1` wide
  def horizontal_blur!(k : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (k + k + 1)

    each_channel do |channel|
      @height.times do |y|
        row__offset : Int32 = y * @width
        left__bound : Int32 = row__offset
        right_bound : Int32 = row__offset + k

        value_at_row_beginning : Int32 = channel.unsafe_fetch(row__offset).to_i
        value_at_row_end : Int32 = channel.unsafe_fetch(row__offset + @width - 1).to_i
        current_sum : Int32 = (k + 1) * value_at_row_beginning

        (0..k - 1).each do |i|
          current_sum += channel.unsafe_fetch(row__offset + i)
        end

        (0..k).each do
          current_sum += channel.unsafe_fetch(right_bound).to_i - value_at_row_beginning
          buffer.unsafe_put(row__offset, (current_sum * multiplier).to_u8)

          right_bound += 1
          row__offset += 1
        end

        (k + 1..@width - k - 1).each do
          current_sum += (channel.unsafe_fetch(right_bound).to_i - channel.unsafe_fetch(left__bound).to_i)
          buffer.unsafe_put(row__offset, (current_sum * multiplier).to_u8)

          right_bound += 1
          left__bound += 1
          row__offset += 1
        end

        (@width - k..@width - 1).each do
          current_sum += value_at_row_end - channel.unsafe_fetch(left__bound).to_i
          buffer.unsafe_put(row__offset, (current_sum * multiplier).to_u8)

          left__bound += 1
          row__offset += 1
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

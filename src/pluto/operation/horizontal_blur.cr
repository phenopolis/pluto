module Pluto::Operation::HorizontalBlur
  def horizontal_blur(radius : Int32) : self
    clone.horizontal_blur!(radius)
  end

  # boxBlurH_4 in Algorithm 4 in [this](https://blog.ivank.net/fastest-gaussian-blur.html) post.
  #
  # This is running a horizontal 1 pixel tall window that is `2 * radius + 1` wide along each row and replacing the
  # center pixel with sum of all pixels in the window multiplied by `1 / (2 * radius + 1)` (i.e. the average
  # of the pixels in the window).
  def horizontal_blur!(radius : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (radius + radius + 1)

    each_channel do |channel|
      @height.times do |y|
        center_index : Int32 = y * @width
        left_index : Int32 = center_index
        right_index : Int32 = center_index + radius

        first_value : Int32 = channel.unsafe_fetch(center_index).to_i
        last_value : Int32 = channel.unsafe_fetch(center_index + @width - 1).to_i
        current_sum : Int32 = (radius + 1) * first_value

        (0..radius - 1).each do |i|
          current_sum += channel.unsafe_fetch(center_index + i)
        end

        (0..radius).each do
          current_sum += channel.unsafe_fetch(right_index).to_i - first_value
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          right_index += 1
          center_index += 1
        end

        (radius + 1..@width - radius - 1).each do
          current_sum += (channel.unsafe_fetch(right_index).to_i - channel.unsafe_fetch(left_index).to_i)
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          right_index += 1
          left_index += 1
          center_index += 1
        end

        (@width - radius..@width - 1).each do
          current_sum += last_value - channel.unsafe_fetch(left_index).to_i
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          left_index += 1
          center_index += 1
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

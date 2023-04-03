module Pluto::Operation::VerticalBlur
  def vertical_blur(radius : Int32) : self
    clone.vertical_blur!(radius)
  end

  # boxBlurT_4 in Algorithm 4 in [this](https://blog.ivank.net/fastest-gaussian-blur.html) post.
  #
  # This is running a vertical 1 pixel wide window that is `2 * radius + 1` tall along each column and replacing the
  # center pixel with sum of all pixels in the window multiplied by `1 / (2 * radius + 1)` (i.e. the average
  # of the pixels in the window).
  def vertical_blur!(radius : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (radius + radius + 1)

    each_channel do |channel|
      @width.times do |x|
        center_index : Int32 = x
        upper_index : Int32 = center_index
        lower_index : Int32 = center_index + radius * @width

        first_value : Int32 = channel.unsafe_fetch(center_index).to_i
        last_value : Int32 = channel.unsafe_fetch(center_index + @width * (@height - 1)).to_i
        current_sum : Int32 = (radius + 1) * first_value

        (0..radius - 1).each do |i|
          current_sum += channel.unsafe_fetch(center_index + i * @width)
        end

        (0..radius).each do
          current_sum += channel.unsafe_fetch(lower_index).to_i - first_value
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          lower_index += @width
          center_index += @width
        end

        (radius + 1..@height - radius - 1).each do
          current_sum += channel.unsafe_fetch(lower_index).to_i - channel.unsafe_fetch(upper_index).to_i
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          upper_index += @width
          lower_index += @width
          center_index += @width
        end

        (@height - radius..@height - 1).each do
          current_sum += last_value - channel.unsafe_fetch(upper_index).to_i
          buffer.unsafe_put(center_index, (current_sum * multiplier).to_u8)

          upper_index += @width
          center_index += @width
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

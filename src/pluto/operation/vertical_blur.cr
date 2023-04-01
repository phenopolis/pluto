module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : self
    clone.vertical_blur!(value)
  end

  # boxBlurT_4 in Algorithm 4 in [this](https://blog.ivank.net/fastest-gaussian-blur.html) post.
  #
  # This is running a vertical window that is `2 * value + 1` tall along each column and replacing the
  # center pixel with sum of all pixels in the window multiplied by `1 / (2 * value + 1)` (i.e. the average
  # of the pixels in the window).
  def vertical_blur!(value : Int32) : self
    buffer = Bytes.new(size, 0)
    multiplier = 1 / (value + value + 1)

    each_channel do |channel|
      @width.times do |x|
        c_index : Int32 = x
        l_index : Int32 = c_index
        r_index : Int32 = c_index + value * @width

        f_value : Int32 = channel.unsafe_fetch(c_index).to_i
        l_value : Int32 = channel.unsafe_fetch(c_index + @width * (@height - 1)).to_i
        c_value : Int32 = (value + 1) * f_value

        (0..value - 1).each do |i|
          c_value += channel.unsafe_fetch(c_index + i * @width)
        end

        (0..value).each do
          c_value += channel.unsafe_fetch(r_index).to_i - f_value
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          r_index += @width
          c_index += @width
        end

        (value + 1..@height - value - 1).each do
          c_value += channel.unsafe_fetch(r_index).to_i - channel.unsafe_fetch(l_index).to_i
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          l_index += @width
          r_index += @width
          c_index += @width
        end

        (@height - value..@height - 1).each do
          c_value += l_value - channel.unsafe_fetch(l_index).to_i
          buffer.unsafe_put(c_index, (c_value * multiplier).to_u8)

          l_index += @width
          c_index += @width
        end
      end

      channel.to_unsafe.copy_from(buffer.to_unsafe, buffer.size)
    end

    self
  end
end

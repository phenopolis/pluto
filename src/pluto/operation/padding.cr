module Pluto::Operation::Padding
  def padding(
    all : Int32 = 0,
    *,
    left : Int32 = 0,
    right : Int32 = 0,
    top : Int32 = 0,
    bottom : Int32 = 0,
    padding_type : PaddingType = PaddingType::Black
  ) : self
    clone.padding!(all, left: left, right: right, top: top, bottom: bottom, padding_type: padding_type)
  end

  def padding!(
    all : Int32 = 0,
    *,
    left : Int32 = 0,
    right : Int32 = 0,
    top : Int32 = 0,
    bottom : Int32 = 0,
    padding_type : PaddingType = PaddingType::Black
  ) : self
    top = top > 0 ? top : all
    bottom = bottom > 0 ? bottom : all
    left = left > 0 ? left : all
    right = right > 0 ? right : all

    new_width = left + width + right
    new_height = top + height + bottom

    each_channel do |channel, channel_type|
      new_channel =
        Array(UInt8).new((top + height + bottom) * new_width) do |i|
          case padding_type
          in PaddingType::Black then 0u8
          in PaddingType::Repeat
            adjusted_y = (i // new_width - top).clamp(0, height - 1)
            channel.unsafe_fetch(adjusted_y * width + (i % new_width - left).clamp(0, width - 1))
          end
        end

      # Now copy the original values into the new raw array at the correct locations.
      height.times do |y|
        adjusted_y = y + top
        (new_channel.to_unsafe + adjusted_y * new_width + left).copy_from(channel.to_unsafe + y * width, width)
      end

      # If the padding type is repeat, then repeat the top and bottom line of pixels, well, on the top and bottom of the image.
      if padding_type.repeat?
        if top > 0
          copy = new_channel[new_width * top, new_width]
          top.times do |i|
            new_channel[i * new_width, new_width] = copy
          end
        end
        if bottom > 0
          copy = new_channel[new_width * (top + height - 1), new_width]
          bottom.times do |i|
            new_channel[(i + top + height) * new_width, new_width] = copy
          end
        end
      end

      self[channel_type] = new_channel
    end

    @width = new_width
    @height = new_height

    self
  end
end

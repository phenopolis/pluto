module Pluto::Operation::Crop
  def [](xrange : Range, yrange : Range) : self
    xstart, xcount = resolve_to_start_and_count(xrange, width)
    ystart, ycount = resolve_to_start_and_count(yrange, height)
    crop(xstart, ystart, xcount, ycount)
  end

  def crop(x : Int32, y : Int32, new_width : Int32, new_height : Int32) : self
    clone.crop!(x, y, new_width, new_height)
  end

  def crop!(x : Int32, y : Int32, new_width : Int32, new_height : Int32) : self
    raise "Crop dimensions extend #{x + new_width - width} pixels beyond width of the image (#{width})" if (x + new_width) > width
    raise "Crop dimensions extend #{y + new_height - height} pixels beyond height of the image (#{height})" if (y + new_height) > height

    new_size = new_width * new_height
    height_offset = y * width

    each_channel do |channel, channel_type|
      resized_channel = Array.new(new_size) { 0u8 }

      new_height.times do |new_y|
        orig_index = height_offset + (new_y * width) + x
        resized_channel[new_y * new_width, new_width] = channel[orig_index, new_width]
      end

      self[channel_type] = resized_channel
    end

    @width = new_width
    @height = new_height

    self
  end
end

module Pluto::Operation::BilinearResize
  def bilinear_resize(width : Int32, height : Int32) : Image
    clone.bilinear_resize!(width, height)
  end

  def bilinear_resize!(width : Int32, height : Int32) : Image
    channels = [@red, @green, @blue, @alpha]
    resized_channels = [] of Array(UInt8)

    x_ratio = width > 1 ? (@width - 1) / (width - 1) : 0
    y_ratio = height > 1 ? (@height - 1) / (height - 1) : 0

    channels.each do |channel|
      resized_channel = Array.new(width * height) { 0u8 }

      height.times do |y|
        width.times do |x|
          x_l = (x_ratio * x).floor.to_i
          y_l = (y_ratio * y).floor.to_i
          x_h = (x_ratio * x).ceil.to_i
          y_h = (y_ratio * y).ceil.to_i

          x_weight = (x_ratio * x) - x_l
          y_weight = (y_ratio * y) - y_l

          a = channel[@width * y_l + x_l]
          b = channel[@width * y_l + x_h]
          c = channel[@width * y_h + x_l]
          d = channel[@width * y_h + x_h]

          pixel = a * (1 - x_weight) * (1 - y_weight) +
                  b * x_weight * (1 - y_weight) +
                  c * y_weight * (1 - x_weight) +
                  d * x_weight * y_weight

          resized_channel[width * y + x] = pixel.to_u8
        end
      end

      resized_channels << resized_channel
    end

    @red = resized_channels[0].to_a
    @green = resized_channels[1].to_a
    @blue = resized_channels[2].to_a
    @alpha = resized_channels[3].to_a
    @width = width
    @height = height

    self
  end
end

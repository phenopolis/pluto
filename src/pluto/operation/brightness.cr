module Pluto::Operation::Brightness
  def brightness(value : Float64) : Image
    clone.brightness!(value)
  end

  def brightness!(value : Float64) : Image
    (@width * @height).times do |index|
      pixel = @pixels.unsafe_fetch(index)
      updated_pixel = RGBA.new(
        Math.min(255, (pixel.red * value)).to_u8,
        Math.min(255, (pixel.green * value)).to_u8,
        Math.min(255, (pixel.blue * value)).to_u8,
        255
      )
      @pixels.unsafe_put(index, updated_pixel)
    end
    self
  end
end

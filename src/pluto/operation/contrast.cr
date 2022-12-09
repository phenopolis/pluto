module Pluto::Operation::Contrast
  def contrast(value : Float64) : Image
    clone.contrast!(value)
  end

  def contrast!(value : Float64) : Image
    factor = (259 * (value + 255)) / (255 * (259 - value))
    (@width * @height).times do |index|
      pixel = @pixels.unsafe_fetch(index)
      updated_pixel = RGBA.new(
        Math.min(255, Math.max(0, factor * (pixel.red.to_i - 128) + 128)).to_u8,
        Math.min(255, Math.max(0, factor * (pixel.green.to_i - 128) + 128)).to_u8,
        Math.min(255, Math.max(0, factor * (pixel.blue.to_i - 128) + 128)).to_u8,
        255
      )
      @pixels.unsafe_put(index, updated_pixel)
    end
    self
  end
end

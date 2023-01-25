module Pluto::Operation::Contrast
  def contrast(value : Float64) : Image
    clone.contrast!(value)
  end

  def contrast!(value : Float64) : Image
    factor = (259 * (value + 255)) / (255 * (259 - value))
    size.times do |index|
      @red.unsafe_put(index, Math.min(255, Math.max(0, factor * (@red.unsafe_fetch(index).to_i - 128) + 128)).to_u8)
      @green.unsafe_put(index, Math.min(255, Math.max(0, factor * (@green.unsafe_fetch(index).to_i - 128) + 128)).to_u8)
      @blue.unsafe_put(index, Math.min(255, Math.max(0, factor * (@blue.unsafe_fetch(index).to_i - 128) + 128)).to_u8)
    end
    self
  end
end

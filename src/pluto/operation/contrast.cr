module Pluto::Operation::Contrast
  def contrast(value : Float64) : Image
    clone.contrast!(value)
  end

  def contrast!(value : Float64) : Image
    factor = (259 * (value + 255)) / (255 * (259 - value))
    each_channel do |channel|
      size.times do |index|
        channel.unsafe_put(index, Math.min(255, Math.max(0, factor * (channel.unsafe_fetch(index).to_i - 128) + 128)).to_u8)
      end
    end
    self
  end
end

module Pluto::Operation::Brightness
  def brightness(value : Float64) : Image
    clone.brightness!(value)
  end

  def brightness!(value : Float64) : Image
    (@width * @height).times do |index|
      @red.unsafe_put(index, Math.min(255, (@red.unsafe_fetch(index) * value)).to_u8)
      @green.unsafe_put(index, Math.min(255, (@green.unsafe_fetch(index) * value)).to_u8)
      @blue.unsafe_put(index, Math.min(255, (@blue.unsafe_fetch(index) * value)).to_u8)
    end
    self
  end
end

module Pluto::Operation::Brightness
  def brightness(value : Float64) : Image
    clone.brightness!(value)
  end

  def brightness!(value : Float64) : Image
    (@width * @height).times do |index|
      @red[index] = Math.min(255, (@red[index] * value)).to_u8
      @green[index] = Math.min(255, (@green[index] * value)).to_u8
      @blue[index] = Math.min(255, (@blue[index] * value)).to_u8
    end
    self
  end
end

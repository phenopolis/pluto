module Pluto::Operations::ChangeBrightness
  def change_brightness(value : Float64) : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    ).change_brightness!(value)
  end

  def change_brightness!(value : Float64) : Image
    (@width * @height).times do |index|
      @red[index] = Math.min(255, (@red[index] * value)).to_u8
      @green[index] = Math.min(255, (@green[index] * value)).to_u8
      @blue[index] = Math.min(255, (@blue[index] * value)).to_u8
    end
    self
  end
end

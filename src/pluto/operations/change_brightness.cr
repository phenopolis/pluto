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
    @height.times do |y|
      @width.times do |x|
        red_byte = Math.min(255, (@red[y][x] * value)).to_u8
        green_byte = Math.min(255, (@green[y][x] * value)).to_u8
        blue_byte = Math.min(255, (@blue[y][x] * value)).to_u8
        @red[y][x] = red_byte
        @green[y][x] = green_byte
        @blue[y][x] = blue_byte
      end
    end
    self
  end
end

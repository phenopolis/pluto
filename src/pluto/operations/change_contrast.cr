module Pluto::Operations::ChangeContrast
  def change_contrast(value : Float64) : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    ).change_contrast!(value)
  end

  def change_contrast!(value : Float64) : Image
    factor = (259 * (value + 255)) / (255 * (259 - value))
    @height.times do |y|
      @width.times do |x|
        red_byte = Math.min(255, Math.max(0, factor * (@red[y][x].to_i - 128) + 128)).to_u8
        green_byte = Math.min(255, Math.max(0, factor * (@green[y][x].to_i - 128) + 128)).to_u8
        blue_byte = Math.min(255, Math.max(0, factor * (@blue[y][x].to_i - 128) + 128)).to_u8
        @red[y][x] = red_byte
        @green[y][x] = green_byte
        @blue[y][x] = blue_byte
      end
    end
    self
  end
end

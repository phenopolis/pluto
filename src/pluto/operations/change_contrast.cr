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
    (@width * @height).times do |index|
      @red[index] = Math.min(255, Math.max(0, factor * (@red[index].to_i - 128) + 128)).to_u8
      @green[index] = Math.min(255, Math.max(0, factor * (@green[index].to_i - 128) + 128)).to_u8
      @blue[index] = Math.min(255, Math.max(0, factor * (@blue[index].to_i - 128) + 128)).to_u8
    end
    self
  end
end

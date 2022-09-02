module Pluto::Filters::ChangeContrast
  def change_contrast(value : Int32) : Image
    self.class.new(@pixels.clone, @width, @height, @type).change_contrast!(value)
  end

  def change_contrast!(value : Int32) : Image
    factor = (259 * (value + 255)) / (255 * (259 - value))
    @height.times do |y|
      @width.times do |x|
        pixel = @pixels[y][x]
        red = Math.min(255u32, Math.max(0, factor * (((pixel & 0xFF000000) >> 24).to_i - 128) + 128).to_u32) << 24
        green = Math.min(255u32, Math.max(0, factor * (((pixel & 0x00FF0000) >> 16).to_i - 128) + 128).to_u32) << 16
        blue = Math.min(255u32, Math.max(0, factor * (((pixel & 0x0000FF00) >> 8).to_i - 128) + 128).to_u32) << 8
        @pixels[y][x] = red | green | blue
      end
    end
    self
  end
end

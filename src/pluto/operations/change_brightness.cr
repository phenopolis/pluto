module Pluto::Operations::ChangeBrightness
  def change_brightness(value : Float64) : Image
    self.class.new(@pixels.clone, @width, @height, @kind).change_brightness!(value)
  end

  def change_brightness!(value : Float64) : Image
    @height.times do |y|
      @width.times do |x|
        pixel = @pixels[y][x]
        red = Math.min(255u32, (((pixel & 0xFF000000) >> 24) * value).to_u32) << 24
        green = Math.min(255u32, (((pixel & 0x00FF0000) >> 16) * value).to_u32) << 16
        blue = Math.min(255u32, (((pixel & 0x0000FF00) >> 8) * value).to_u32) << 8
        @pixels[y][x] = red | green | blue
      end
    end
    self
  end
end

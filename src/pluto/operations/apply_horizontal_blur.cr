module Pluto::Operations::ApplyHorizontalBlur
  def apply_horizontal_blur(value : Int32) : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    ).apply_horizontal_blur!(value)
  end

  def apply_horizontal_blur!(value : Int32) : Image
    w = @width
    h = @height
    r = value
    channels = [@red, @green, @blue, @alpha].map(&.map(&.to_i))
    blurred_channels = [] of Array(UInt8)

    channels.each do |scl|
      tcl = Array.new(scl.size) { 0u8 }
      iarr = 1 / (value + value + 1)
      h.times do |i|
        ti = i * w; li = ti; ri = ti + r
        fv = scl[ti]; lv = scl[ti + w - 1]; val = (r + 1) * fv
        (0..r - 1).each do |j|
          val = scl[ti + j]
        end
        (0..r).each do
          val += scl[ri] - fv
          ri += 1
          tcl[ti] = (val * iarr).round.to_u8
          ti += 1
        end
        (r + 1..w - r - 1).each do
          val += scl[ri] - scl[li]
          ri += 1
          li += 1
          tcl[ti] = (val * iarr).round.to_u8
          ti += 1
        end
        (w - r..w - 1).each do
          val += lv - scl[li]
          li += 1
          tcl[ti] = (val * iarr).round.to_u8
          ti += 1
        end
      end
      blurred_channels << tcl
    end

    @red = blurred_channels[0]
    @green = blurred_channels[1]
    @blue = blurred_channels[2]
    @alpha = blurred_channels[3]

    self
  end
end

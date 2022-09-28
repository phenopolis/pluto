module Pluto::Operations::ApplyVerticalBlur
  def apply_vertical_blur(value : Int32) : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    ).apply_vertical_blur!(value)
  end

  def apply_vertical_blur!(value : Int32) : Image
    w = @width
    h = @height
    r = value
    channels = [@red, @green, @blue, @alpha].map(&.flatten.map(&.to_i))
    blurred_channels = [] of Array(UInt8)

    channels.each do |scl|
      tcl = Array.new(scl.size) { 0u8 }
      iarr = 1 / (r + r + 1)
      w.times do |i|
        ti = i; li = ti; ri = ti + r * w
        fv = scl[ti]; lv = scl[ti + w * (h - 1)]; val = (r + 1) * fv
        (0..r - 1).each do |j|
          val += scl[ti + j * w]
        end
        (0..r).each do
          val += scl[ri] - fv
          tcl[ti] = (val * iarr).round.to_u8
          ri += w
          ti += w
        end
        (r + 1..h - r - 1).each do
          val += scl[ri] - scl[li]
          tcl[ti] = (val * iarr).round.to_u8
          li += w
          ri += w
          ti += w
        end
        (h - r..h - 1).each do
          val += lv - scl[li]
          tcl[ti] = (val * iarr).round.to_u8
          li += w
          ti += w
        end
      end
      blurred_channels << tcl
    end

    @red = blurred_channels[0].each_slice(width).to_a
    @green = blurred_channels[1].each_slice(width).to_a
    @blue = blurred_channels[2].each_slice(width).to_a
    @alpha = blurred_channels[3].each_slice(width).to_a

    self
  end
end

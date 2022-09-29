require "./bindings/*"
require "./formats/*"
require "./operations/*"

class Pluto::Image
  include Formats::JPEG
  include Formats::PPM

  include Operations::ApplyBoxBlur
  include Operations::ApplyGaussianBlur
  include Operations::ApplyHorizontalBlur
  include Operations::ApplyVerticalBlur
  include Operations::ChangeBrightness
  include Operations::ChangeContrast
  include Operations::SwapChannels

  enum Channel
    Red
    Green
    Blue
  end

  getter red : Array(UInt8)
  getter green : Array(UInt8)
  getter blue : Array(UInt8)
  getter alpha : Array(UInt8)
  getter width : Int32
  getter height : Int32

  def initialize(@red, @green, @blue, @alpha, @width, @height)
  end

  def clone : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    )
  end
end

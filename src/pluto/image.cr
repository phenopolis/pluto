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
  include Operations::BilinearResize
  include Operations::ChangeBrightness
  include Operations::ChangeContrast
  include Operations::SwapChannels

  enum Channel
    Red
    Green
    Blue
  end

  property red : Array(UInt8)
  property green : Array(UInt8)
  property blue : Array(UInt8)
  property alpha : Array(UInt8)
  property width : Int32
  property height : Int32

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

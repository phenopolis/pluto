require "./bindings/*"
require "./format/*"
require "./operation/*"

class Pluto::Image
  include Format::JPEG
  include Format::PPM

  include Operation::BilinearResize
  include Operation::BoxBlur
  include Operation::Brightness
  include Operation::ChannelSwap
  include Operation::Contrast
  include Operation::GaussianBlur
  include Operation::HorizontalBlur
  include Operation::VerticalBlur

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

  def size : Int32
    @width * @height
  end
end

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

  property pixels : Array(RGBA)
  property width : Int32
  property height : Int32

  def initialize(@pixels, @width, @height)
  end

  def size : Int32
    @width * @height
  end

  def clone : Image
    self.class.new(
      @pixels.clone,
      @width,
      @height
    )
  end
end

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

  private def each_channel(&)
    yield @red, Channel::Red
    yield @green, Channel::Green
    yield @blue, Channel::Blue
    yield @alpha, Channel::Alpha
  end

  private def [](ch : Channel)
    case ch
    when Channel::Red   then @red
    when Channel::Green then @green
    when Channel::Blue  then @blue
    when Channel::Alpha then @alpha
    else                     raise "Unknown channel #{ch} for Image"
    end
  end

  private def []=(ch : Channel, channel : Array(UInt8))
    case ch
    when Channel::Red   then @red = channel
    when Channel::Green then @green = channel
    when Channel::Blue  then @blue = channel
    when Channel::Alpha then @alpha = channel
    else                     raise "Unknown channel #{ch} for Image"
    end
  end

  def size : Int32
    @width * @height
  end
end

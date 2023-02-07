require "./bindings/*"
require "./format/*"
require "./operation/*"

class Pluto::GreyImage
  include Format::JPEG
  include Format::PPM
  include Format::FileOperations

  include Operation::BilinearResize
  include Operation::BoxBlur
  include Operation::Brightness
  include Operation::ChannelSwap
  include Operation::Contrast
  include Operation::GaussianBlur
  include Operation::HorizontalBlur
  include Operation::VerticalBlur

  getter grey : Array(UInt8)
  getter width : Int32
  getter height : Int32

  def initialize(@grey, @width, @height)
  end

  def clone : GreyImage
    self.class.new(
      @grey.clone,
      @width,
      @height
    )
  end

  def red : Array(UInt8)
    @grey
  end

  def green : Array(UInt8)
    @grey
  end

  def blue : Array(UInt8)
    @grey
  end

  def grey=(new_grey : Array(UInt8)) : Array(UInt8)
    raise "New grey channel must be of size #{size}, but is #{new_grey.size}" unless size == new_grey.size
    @grey = new_grey
  end

  def each_channel(&) : Nil
    yield @grey, ChannelType::Grey
    nil
  end

  def [](channel_type : ChannelType) : Array(UInt8)
    # All channels are grey. There can only be grey.
    @grey
  end

  def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
    case channel_type
    when ChannelType::Grey then @grey = channel
    else                        raise "Unknown channel type #{channel_type} for GreyImage"
    end
  end

  def size : Int32
    @width * @height
  end
end

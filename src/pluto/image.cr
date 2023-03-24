require "./bindings/*"
require "./format/*"
require "./operation/*"

abstract class Pluto::Image
  macro inherited
    include Format::JPEG
    include Format::PNG
    include Format::PPM
    include Format::WebP

    include Operation::BilinearResize
    include Operation::BoxBlur
    include Operation::Brightness
    include Operation::ChannelSwap
    include Operation::Contrast
    include Operation::GaussianBlur
    include Operation::HorizontalBlur
    include Operation::VerticalBlur
    include Operation::Crop
  end

  abstract def red : Array(UInt8)
  abstract def green : Array(UInt8)
  abstract def blue : Array(UInt8)
  abstract def alpha : Array(UInt8)
  abstract def width : Int32
  abstract def height : Int32
  abstract def [](channel_type : ChannelType) : Array(UInt8)
  abstract def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
  abstract def each_channel(& : (Array(UInt8), ChannelType) -> Nil) : Nil

  def size : Int32
    width * height
  end

  private def resolve_to_start_and_count(range, size) : Tuple(Int32, Int32)
    start, count = Indexable.range_to_index_and_count(range, size) || raise IndexError.new("Unable to resolve range #{range} for image dimension of #{size}")
    raise IndexError.new("Range #{range} exceeds bounds of #{size}") if (start + count) > size
    {start, count}
  end
end

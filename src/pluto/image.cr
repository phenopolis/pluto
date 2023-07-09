require "./format/ppm"
require "./format/stumpy"
require "./operation/*"

abstract class Pluto::Image
  macro inherited
    include Format::PPM
    include Format::Stumpy

    include Operation::BilinearResize
    include Operation::BoxBlur
    include Operation::Brightness
    include Operation::ChannelSwap
    include Operation::Contrast
    include Operation::Crop
    include Operation::GaussianBlur
    include Operation::HorizontalBlur
    include Operation::Padding
    include Operation::VerticalBlur
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
end

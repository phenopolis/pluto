require "./operations/*"
require "./formats/*"

class Pluto::Image
  include Operations::ApplyHorizontalBlur
  include Operations::ApplyVerticalBlur
  include Operations::ChangeBrightness
  include Operations::ChangeContrast
  include Operations::SwapChannels

  include Formats::JPEG
  include Formats::PPM

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
end

require "./operations/*"
require "./formats/*"

class Pluto::Image
  include Operations::ChangeBrightness
  include Operations::ChangeContrast
  include Operations::SwapChannels

  include Formats::JPEG
  include Formats::PPM

  getter red : Array(Array(UInt8))
  getter green : Array(Array(UInt8))
  getter blue : Array(Array(UInt8))
  getter alpha : Array(Array(UInt8))
  getter width : Int32
  getter height : Int32

  def initialize(@red, @green, @blue, @alpha, @width, @height)
  end
end

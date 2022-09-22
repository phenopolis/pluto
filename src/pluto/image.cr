require "./operations/*"
require "./formats/*"

class Pluto::Image
  include Operations::ChangeBrightness
  include Operations::ChangeContrast
  include Operations::SwapChannels

  include Formats::JPEG
  include Formats::PPM

  getter pixels : Array(Array(UInt32))
  getter width : Int32
  getter height : Int32

  def initialize(@pixels, @width, @height)
  end
end

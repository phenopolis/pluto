require "./formats/*"

class Pluto::Image
  include Formats::JPEG
  include Formats::PPM

  getter pixels : Array(Array(UInt32))
  getter width : Int32
  getter height : Int32
  getter type : Type

  enum Type
    Binary
    Grayscale
    RGB
    RGBA
  end

  def initialize(@pixels, @width, @height, @type)
  end
end

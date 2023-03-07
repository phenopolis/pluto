require "./image"
require "./bindings/*"
require "./format/*"
require "./operation/*"

class Pluto::RGBAImage < Pluto::Image
  property red : Array(UInt8)
  property green : Array(UInt8)
  property blue : Array(UInt8)
  property alpha : Array(UInt8)
  property width : Int32
  property height : Int32

  def initialize(@red, @green, @blue, @alpha, @width, @height)
  end

  def clone : RGBAImage
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    )
  end

  def each_channel(&) : Nil
    yield @red, ChannelType::Red
    yield @green, ChannelType::Green
    yield @blue, ChannelType::Blue
    yield @alpha, ChannelType::Alpha
    nil
  end

  def [](channel_type : ChannelType) : Array(UInt8)
    case channel_type
    when ChannelType::Red   then @red
    when ChannelType::Green then @green
    when ChannelType::Blue  then @blue
    when ChannelType::Alpha then @alpha
    else                         raise "Unknown channel type #{channel_type} for RGBAImage"
    end
  end

  def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
    case channel_type
    when ChannelType::Red   then @red = channel
    when ChannelType::Green then @green = channel
    when ChannelType::Blue  then @blue = channel
    when ChannelType::Alpha then @alpha = channel
    else                         raise "Unknown channel type #{channel_type} for RGBAImage"
    end
  end

  # Convert color image to grayscale one, using the NTSC formula as default values.
  def to_gray(red_multiplier : Float = 0.299, green_multiplier : Float = 0.587, blue_multiplier : Float = 0.114)
    GrayscaleImage.new(
      red.map_with_index do |red_pixel, index|
        Math.min(
          255u8,
          (red_pixel * red_multiplier + @green[index] * green_multiplier + @blue[index] * blue_multiplier).to_u8
        )
      end,
      width,
      height
    )
  end

  def size : Int32
    @width * @height
  end
end

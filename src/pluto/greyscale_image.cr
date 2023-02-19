require "./image"

class Pluto::GreyscaleImage < Pluto::Image
  property grey : Array(UInt8)
  property width : Int32
  property height : Int32

  def self.new(red : Array(UInt8), green : Array(UInt8), blue : Array(UInt8), alpha : Array(UInt8), width : Int32, height : Int32)
    RGBAImage.new(red, green, blue, alpha, width, height).to_grey
  end

  def initialize(@grey, @width, @height)
  end

  def clone : GreyscaleImage
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

  def alpha : Array(UInt8)
    @grey
  end

  def each_channel(& : (Array(UInt8), ChannelType) -> Nil) : Nil
    yield @grey, ChannelType::Grey
    nil
  end

  def [](channel_type : ChannelType) : Array(UInt8)
    # All channels are grey. There can only be grey.
    @grey
  end

  def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
    case channel_type
    when ChannelType::Grey then self.grey = channel
    else                        raise "Unknown channel type #{channel_type} for GreyscaleImage"
    end
  end

  def to_rgba
    RGBAImage.new(@grey.clone, @grey.clone, @grey.clone, Array(UInt8).new(size) { 1u8 }, width, height)
  end

  def size : Int32
    @width * @height
  end
end

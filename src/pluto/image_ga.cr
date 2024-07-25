require "./image"

class Pluto::ImageGA < Pluto::Image
  property gray : Array(UInt8)
  property alpha : Array(UInt8)
  property width : Int32
  property height : Int32

  def self.new(
    red : Array(UInt8),
    green : Array(UInt8),
    blue : Array(UInt8),
    alpha : Array(UInt8),
    width : Int32,
    height : Int32
  )
    ImageRGBA.new(red, green, blue, alpha, width, height).to_ga
  end

  def initialize(@gray, @alpha, @width, @height)
  end

  def clone : ImageGA
    self.class.new(
      @gray.clone,
      @alpha.clone,
      @width,
      @height
    )
  end

  def red : Array(UInt8)
    @gray
  end

  def green : Array(UInt8)
    @gray
  end

  def blue : Array(UInt8)
    @gray
  end

  def each_channel(& : (Array(UInt8), ChannelType) -> Nil) : Nil
    yield @gray, ChannelType::Gray
    yield @alpha, ChannelType::Alpha
    nil
  end

  def [](channel_type : ChannelType) : Array(UInt8)
    case channel_type
    when ChannelType::Gray  then @gray
    when ChannelType::Alpha then @alpha
    else                         raise Exception.new("Unknown channel type #{channel_type} for ImageRGBA")
    end
  end

  def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
    case channel_type
    when ChannelType::Gray  then self.gray = channel
    when ChannelType::Alpha then self.alpha = channel
    else                         raise Exception.new("Unknown channel type #{channel_type} for ImageGA")
    end
  end

  def to_rgba : ImageRGBA
    ImageRGBA.new(@gray.clone, @gray.clone, @gray.clone, @alpha.clone, width, height)
  end
end

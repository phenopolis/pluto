require "./image"

class Pluto::GrayscaleImage < Pluto::Image
  property gray : Array(UInt8)
  property width : Int32
  property height : Int32

  def self.new(red : Array(UInt8), green : Array(UInt8), blue : Array(UInt8), alpha : Array(UInt8), width : Int32, height : Int32)
    RGBAImage.new(red, green, blue, alpha, width, height).to_gray
  end

  def initialize(@gray, @width, @height)
  end

  def clone : GrayscaleImage
    self.class.new(
      @gray.clone,
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

  def alpha : Array(UInt8)
    @gray
  end

  def each_channel(& : (Array(UInt8), ChannelType) -> Nil) : Nil
    yield @gray, ChannelType::Gray
    nil
  end

  def [](channel_type : ChannelType) : Array(UInt8)
    # All channels are gray. There can only be gray.
    @gray
  end

  def []=(channel_type : ChannelType, channel : Array(UInt8)) : Array(UInt8)
    case channel_type
    when ChannelType::Gray then self.gray = channel
    else                        raise "Unknown channel type #{channel_type} for GrayscaleImage"
    end
  end

  def to_rgba
    RGBAImage.new(@gray.clone, @gray.clone, @gray.clone, Array(UInt8).new(size) { 255u8 }, width, height)
  end

  def size : Int32
    @width * @height
  end

  def mask_from(&block : (Int32, Int32, UInt8) -> Bool) : Mask
    Mask.new(width, BitArray.new(size) do |i|
      block.call(i % width, i // width, @gray[i])
    end)
  end

  def threshold(threshold : Int) : Mask
    mask_from do |_, _, pixel|
      pixel >= threshold
    end
  end
end

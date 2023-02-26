require "bit_array"

# Mask is a wrapper around BitArray, where each flag represents a boolean bit of information about a pixel
# from an image. This can include whether a particular pixel has a value within certain conditions, OR
# if that pixel should be zeroed out or not.
#
#
# (x,y) - coordinates. Represent these positions in a Mask of size 10x10:
#
# [
#   (0,0), (0,1), (0,2), (0,3), (0,4), (0,5), (0,6), (0,7), (0,8), (0,9),
#   (1,0), (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9),
#   (2,0), (2,1), (2,2), (2,3), (2,4), (2,5), (2,6), (2,7), (2,8), (2,9),
#   (3,0), (3,1), (3,2), (3,3), (3,4), (3,5), (3,6), (3,7), (3,8), (3,9),
#   (4,0), (4,1), (4,2), (4,3), (4,4), (4,5), (4,6), (4,7), (4,8), (4,9),
#   (5,0), (5,1), (5,2), (5,3), (5,4), (5,5), (5,6), (5,7), (5,8), (5,9),
#   (6,0), (6,1), (6,2), (6,3), (6,4), (6,5), (6,6), (6,7), (6,8), (6,9),
#   (7,0), (7,1), (7,2), (7,3), (7,4), (7,5), (7,6), (7,7), (7,8), (7,9),
#   (8,0), (8,1), (8,2), (8,3), (8,4), (8,5), (8,6), (8,7), (8,8), (8,9),
#   (9,0), (9,1), (9,2), (9,3), (9,4), (9,5), (9,6), (9,7), (9,8), (9,9),
# ]
#
# And every position is a Bool value.
#
# Different ways to refer to coordinates
# mask[0, 0] # => (0,0)
# mask.at(0, 0) # => (0,0)
# mask[0] # => (0,0), (1,0), (2,0), ..., (9,0)
# mask[0..1] # => (0,0), (1,0), ..., (9,0), (0,1), (1,1), ..., (9,1)
# mask[0..1, 4] # => (4,0), (4,1)
# mask[3, 3..5] # => (3,3), (3,4), (3,5)
# mask[2..3, 4..5] # => (2,4), (2,5), (3,4), (3,5)
class Pluto::Mask
  getter width : Int32
  getter bits : BitArray

  def initialize(@width, @bits)
    raise "BitArray size #{@bits.size} must be an even number of #{@width}" unless (@bits.size % @width) == 0
  end

  def initialize(@width, height : Int32)
    @bits = BitArray.new(@width * height, true)
  end

  def initialize(@width, height : Int32, &block : (Int32, Int32) -> Bool)
    @bits = BitArray.new(@width * height) do |i|
      block.call(i % @width, i // @width)
    end
  end

  def initialize(@width, height : Int32, int : Int)
    size = @width * height
    @bits = BitArray.new(size) { |i| int.bit(size - i - 1) > 0 }
  end

  def initialize(image : Image)
    @width = image.width
    @bits = BitArray.new(image.size, true)
  end

  def initialize(other_bits : Array(BitArray))
    raise "Can't create an empty mask" if other_bits.empty?
    raise "Can't create an empty mask, first array is empty" if other_bits[0].empty?
    raise "All sub arrays must be the same size" unless other_bits.map(&.size).uniq!.size == 1

    @width = other_bits[0].size
    @bits = BitArray.new(other_bits.size * @width)
    other_bits.each_with_index do |arr, i|
      arr.each_with_index do |bool, j|
        @bits[i * @width + j] = bool
      end
    end
  end

  delegate size, to: bits

  def height : Int32
    @bits.size // width
  end

  def invert!
    @bits.invert
    self
  end

  def invert
    new_bits = @bits.dup
    new_bits.invert
    Mask.new(width, new_bits)
  end

  def [](x : Int32, y : Int32) : Bool
    raise IndexError.new("Out of bounds: this mask is #{width}x#{height}, and (#{x},#{y}) is outside of that") if x >= width || y >= height
    @bits[y * width + x]
  end

  def at(index : Int32) : Bool
    raise "Index #{index} exceeds mask size #{@bits.size}" if index >= size
    @bits[index]
  end

  private def resolve_to_start_and_count(range, size) : Tuple(Int32, Int32)
    start, count = Indexable.range_to_index_and_count(range, size) || raise IndexError.new("Unable to resolve range #{range} for mask dimension of #{size}")
    raise IndexError.new("Range #{range} exceeds bounds of #{size}") if (start + count) > size
    {start, count}
  end

  def [](xs : Range(Int32, Int32) | Range(Int32, Nil), y : Int32) : BitArray
    start, count = resolve_to_start_and_count(xs, width)
    BitArray.new(count) { |x| self[x + start, y] }
  end

  def [](x : Int32, ys : Range(Int32, Int32) | Range(Int32, Nil)) : BitArray
    start, count = resolve_to_start_and_count(ys, height)
    BitArray.new(count) { |y| self[x, y + start] }
  end

  def [](xs : Range(Int32, Int32) | Range(Int32, Nil), ys : Range(Int32, Int32) | Range(Int32, Nil)) : Array(BitArray)
    start_x, count_x = resolve_to_start_and_count(xs, width)
    start_y, count_y = resolve_to_start_and_count(ys, height)
    count_y.times.to_a.map do |y|
      BitArray.new(count_x) do |x|
        self[x + start_x, y + start_y]
      end
    end
  end

  def ==(other : Mask)
    width == other.width &&
      bits == other.bits
  end

  def set(x : Int32, y : Int32, value : Bool) : Bool
    raise IndexError.new("Out of bounds: this mask is #{width}x#{height}, and (#{x},#{y}) is outside of that") if x >= width || y >= height
    @bits[y * width + x] = value
  end

  def []=(x : Int32, y : Int32, value : Bool) : Bool
    self.set(x, y, value)
  end

  def []=(xs : Range(Int32, Int32) | Range(Int32, Nil), y : Int32, value : Bool) : Bool
    raise IndexError.new("Out of bounds: #{y} is beyond the bounds of this mask's height of #{height}") if y >= height
    start_x, count_x = resolve_to_start_and_count(xs, width)
    @bits.fill(value, y * width + start_x, count_x)
    value
  end

  def []=(x : Int32, ys : Range(Int32, Int32) | Range(Int32, Nil), value : Bool) : Bool
    raise IndexError.new("Out of bounds: #{x} is beyond the bounds of this mask's width of #{width}") if x >= width
    start_y, count_y = resolve_to_start_and_count(ys, height)
    count_y.times.to_a.each do |y|
      set(x, y + start_y, value)
    end
    value
  end

  def []=(xs : Range(Int32, Int32) | Range(Int32, Nil), ys : Range(Int32, Int32) | Range(Int32, Nil), value : Bool) : Bool
    # IMPL: check ranges
    start_x, count_x = resolve_to_start_and_count(xs, width)
    start_y, count_y = resolve_to_start_and_count(ys, height)
    count_y.times.to_a.each do |y|
      @bits.fill(value, (y + start_y) * width + start_x, count_x)
    end
    value
  end

  def to_gray
    GrayscaleImage.new(bits.map { |b| b ? 255u8 : 0u8 }, width, height)
  end

  def apply(image : Image) : Image
    image.apply(self)
  end
end

ZERO_PIXEL = RGBA.new(0, 0, 0, 0)

struct RGBA
  property r, g, b, a

  def initialize(@r : UInt8, @g : UInt8, @b : UInt8, @a : UInt8)
  end

  def initialize(array : StaticArray(UInt8, 4))
    @r = array.unsafe_fetch(0)
    @g = array.unsafe_fetch(1)
    @b = array.unsafe_fetch(2)
    @a = array.unsafe_fetch(3)
  end
end

require "./bindings/*"
require "./format/*"
require "./operation/*"

class Pluto::Image
  include Format::JPEG
  include Format::PPM

  include Operation::BilinearResize
  include Operation::BoxBlur
  include Operation::Brightness
  include Operation::ChannelSwap
  include Operation::Contrast
  include Operation::GaussianBlur
  include Operation::HorizontalBlur
  include Operation::VerticalBlur

  property red : Array(UInt8)
  property green : Array(UInt8)
  property blue : Array(UInt8)
  property alpha : Array(UInt8)
  property width : Int32
  property height : Int32

  property pixels : Array(RGBA)
  property scratch : Slice(RGBA)

  def initialize(@red, @green, @blue, @alpha, @width, @height)
    @pixels = Array(RGBA).new(size, ZERO_PIXEL)
    @scratch = Slice(RGBA).new(size, ZERO_PIXEL)

    i = 0
    @pixels.map! do |p|
      p.r = @red[i]
      p.g = @green[i]
      p.b = @blue[i]
      p.a = @alpha[i]
      i += 1
      p
    end
  end

  def save_scratch
    @pixels.@buffer.copy_from(@scratch.to_unsafe, @scratch.size)
  end

  macro get_pixel(idx)
    @pixels.unsafe_fetch({{idx}})
    #@pixels[{{idx}}]
  end

  macro set_pixel(idx, pixel)
    @scratch.unsafe_put({{idx}}, {{pixel}})
    #@scratch[{{idx}}] = {{pixel}}
  end

  def size : Int32
    @width * @height
  end

  def clone : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    )
  end

  # 1D blur convolution adopted from https://blog.ivank.net/fastest-gaussian-blur.html
  # This function can be used for both horizontal and vertical blue by setting the
  # step, stride, and row parameters correctly.
  private def blur(rad, step, stride, row_len, row_count)
    ideal = 1 / (rad + rad + 1)

    # pixel used to write to output
    w_px = ZERO_PIXEL

    x = 0
    i = 0
    while i < row_count
      t_idx = x
      l_idx = t_idx
      r_idx = x + (step * rad)

      f_px = get_pixel(x)
      l_px = get_pixel(x + (step * row_len) - 1)

      # accumulators
      r_sum : Int32 = f_px.r.to_i32 * (rad + 1)
      g_sum : Int32 = f_px.g.to_i32 * (rad + 1)
      b_sum : Int32 = f_px.b.to_i32 * (rad + 1)

      # start left edge blur
      j = 0
      while j < rad
        px = get_pixel(t_idx)
        r_sum += px.r
        g_sum += px.g
        b_sum += px.b
        t_idx += step
        j += 1
      end

      # reset t_idx
      t_idx = x

      # write left edge blur
      j = 0
      while j <= rad
        _px = get_pixel(r_idx)
        r_sum += _px.r.to_i32 - f_px.r
        g_sum += _px.g.to_i32 - f_px.g
        b_sum += _px.b.to_i32 - f_px.b

        w_px.r = (r_sum * ideal).to_u8
        w_px.g = (g_sum * ideal).to_u8
        w_px.b = (b_sum * ideal).to_u8

        set_pixel(t_idx, w_px)

        t_idx += step
        r_idx += step
        j += 1
      end

      # write mid blur
      j = rad + 1
      while j < row_len - rad
        _r_px = get_pixel(r_idx)
        _l_px = get_pixel(l_idx)

        r_sum += _r_px.r.to_i32 - _l_px.r
        g_sum += _r_px.g.to_i32 - _l_px.g
        b_sum += _r_px.b.to_i32 - _l_px.b

        w_px.r = (r_sum * ideal).to_u8
        w_px.g = (g_sum * ideal).to_u8
        w_px.b = (b_sum * ideal).to_u8

        set_pixel(t_idx, w_px)

        t_idx += step
        l_idx += step
        r_idx += step
        j += 1
      end

      # write right-edge blur
      j = row_len - rad
      while j < row_len
        _px = get_pixel(l_idx)
        r_sum += l_px.r.to_i32 - _px.r
        g_sum += l_px.g.to_i32 - _px.g
        b_sum += l_px.b.to_i32 - _px.b

        w_px.r = (r_sum * ideal).to_u8
        w_px.g = (g_sum * ideal).to_u8
        w_px.b = (b_sum * ideal).to_u8

        set_pixel(t_idx, w_px)

        t_idx += step
        l_idx += step
        j += 1
      end

      x += stride
      i += 1
    end

    save_scratch
  end
end

module Pluto::Operation::LanczosResize
  def lanczos_resize(width : Int32, height : Int32, a : Int32 = 3) : self
    clone.lanczos_resize!(width, height, a)
  end

  def lanczos_resize!(width : Int32, height : Int32, a : Int32 = 3) : self
    # Center-aligned coordinate mapping
    x_scale = width.to_f / @width.to_f
    y_scale = height.to_f / @height.to_f

    each_channel do |channel, channel_type|
      resized_channel = Array.new(width * height, 0u8)

      height.times do |h|
        width.times do |w|
          # Proper center-based sampling
          src_x = (w + 0.5) / x_scale - 0.5
          src_y = (h + 0.5) / y_scale - 0.5

          # Correct window calculation
          x_min = (src_x - a).floor.to_i.clamp(0, @width - 1)
          x_max = (src_x + a).floor.to_i.clamp(0, @width - 1)
          y_min = (src_y - a).floor.to_i.clamp(0, @height - 1)
          y_max = (src_y + a).floor.to_i.clamp(0, @height - 1)

          sum = 0.0
          total_weight = 0.0

          x_min.upto(x_max) do |x_pixel|
            dx = x_pixel - src_x
            next if dx.abs >= a # Strict Lanczos cutoff

            weight_x = lanczos_kernel(dx, a)
            next if weight_x == 0.0

            y_min.upto(y_max) do |y_pixel|
              dy = y_pixel - src_y
              next if dy.abs >= a

              weight_y = lanczos_kernel(dy, a)
              next if weight_y == 0.0

              pixel_value = channel.unsafe_fetch(y_pixel * @width + x_pixel).to_f
              sum += pixel_value * weight_x * weight_y
              total_weight += weight_x * weight_y
            end
          end

          if total_weight != 0.0
            value = (sum / total_weight).round.to_i.clamp(0, 255)
          else
            # Fallback to nearest neighbor
            x_nearest = src_x.round.to_i.clamp(0, @width - 1)
            y_nearest = src_y.round.to_i.clamp(0, @height - 1)
            value = channel.unsafe_fetch(y_nearest * @width + x_nearest)
          end

          resized_channel.unsafe_put(h * width + w, value.to_u8)
        end
      end

      self[channel_type] = resized_channel
    end

    @width = width
    @height = height

    self
  end

  private def lanczos_kernel(x : Float64, a : Int32) : Float64
    return 0.0 if x.abs >= a
    return 1.0 if x == 0.0

    px = Math::PI * x
    pxa = Math::PI * x / a

    (Math.sin(px) / px) * (Math.sin(pxa) / pxa)
  rescue
    0.0
  end
end

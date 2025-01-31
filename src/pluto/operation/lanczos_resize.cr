module Pluto::Operation::LanczosResize
  def lanczos_resize(width : Int32, height : Int32, a : Int32 = 3) : self
    clone.lanczos_resize!(width, height, a)
  end

  def lanczos_resize!(width : Int32, height : Int32, a : Int32 = 3) : self
    h_contributors = compute_contributors(@width, width, a)
    v_contributors = compute_contributors(@height, height, a)

    each_channel do |channel, channel_type|
      intermediate = Array.new(width * @height, 0.0)

      parallel_rows(@height) do |y|
        width.times do |x|
          process_horizontal(channel, intermediate, h_contributors[x], y, x, width)
        end
      end

      resized_channel = Array.new(width * height, 0u8)
      parallel_columns(width) do |x|
        height.times do |y|
          sum = process_vertical(intermediate, v_contributors[y], y, x, width, @height)
          resized_channel[y * width + x] = sum.round.clamp(0, 255).to_u8
        end
      end

      self[channel_type] = resized_channel
    end

    @width = width
    @height = height
    self
  end

  private def process_horizontal(source, intermediate, contributor, y, x, new_width)
    sum = 0.0
    y_times_width = y * @width
    contributor.pixels.each_with_index do |src_x, i|
      src_idx = y_times_width + src_x
      sum += source[src_idx].to_f * contributor.weights[i]
    end
    intermediate[y * new_width + x] = sum
  end

  private def process_vertical(intermediate, contributor, y, x, new_width, src_height)
    sum = 0.0
    contributor.pixels.each_with_index do |src_y, i|
      src_idx = src_y * new_width + x
      sum += intermediate[src_idx] * contributor.weights[i]
    end
    sum
  end

  private def parallel_rows(size : Int32, batch_size : Int32 = 32, &block : Int32 -> _)
    channel = Channel(Nil).new
    fibers = (size + batch_size - 1) // batch_size

    fibers.times do |i|
      spawn do
        start = i * batch_size
        finish = Math.min(start + batch_size - 1, size - 1)
        start.upto(finish) { |row| block.call(row) }
        channel.send(nil)
      end
    end

    fibers.times { channel.receive }
  end

  private def parallel_columns(size : Int32, batch_size : Int32 = 32, &block : Int32 -> _)
    channel = Channel(Nil).new
    fibers = (size + batch_size - 1) // batch_size

    fibers.times do |i|
      spawn do
        start = i * batch_size
        finish = Math.min(start + batch_size - 1, size - 1)
        start.upto(finish) { |col| block.call(col) }
        channel.send(nil)
      end
    end

    fibers.times { channel.receive }
  end

  private record Contributor, pixels : Array(Int32), weights : Array(Float64)

  private def compute_contributors(src_size : Int32, dst_size : Int32, a : Int32)
    scale = dst_size > 1 ? (src_size - 1).to_f / (dst_size - 1).to_f : 0.0

    Array.new(dst_size) do |n|
      src_pos = n.to_f * scale
      x_min = (src_pos - a + 1).floor.to_i.clamp(0, src_size - 1)
      x_max = (src_pos + a).floor.to_i.clamp(0, src_size - 1)

      weights = x_min.upto(x_max).map do |i|
        dx = i - src_pos
        dx.abs >= a ? 0.0 : lanczos_kernel(dx, a)
      end.to_a

      total = weights.sum
      if total.abs < 1e-6
        nearest = src_pos.round.to_i.clamp(0, src_size - 1)
        Contributor.new([nearest], [1.0])
      else
        weights = weights.map { |w| w / total }
        Contributor.new((x_min..x_max).to_a, weights)
      end
    end
  end

  private def lanczos_kernel(x, a)
    return 0.0 if x.abs >= a
    return 1.0 if x == 0.0
    px = Math::PI * x
    (Math.sin(px) / px) * (Math.sin(px / a) / (px / a))
  end
end

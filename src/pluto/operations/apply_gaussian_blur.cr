module Pluto::Operations::ApplyGaussianBlur
  def apply_gaussian_blur(value : Int32) : Image
    clone.apply_gaussian_blur!(value)
  end

  def apply_gaussian_blur!(value : Int32) : Image
    sigma = value
    n = 3

    w_ideal = Math.sqrt((12 * sigma * sigma / n) + 1)
    wl = w_ideal.floor
    wl -= 1 if wl % 2 == 0
    wu = wl + 2

    m_ideal = (12 * sigma * sigma - n * wl * wl - 4 * n * wl - 3 * n) / (-4 * wl - 4)
    m = m_ideal.round

    sizes = [] of Float64
    n.times do |i|
      sizes << if i < m
        wl
      else
        wu
      end
    end

    apply_box_blur!(((sizes[0] - 1) // 2).to_i)
    apply_box_blur!(((sizes[1] - 1) // 2).to_i)
    apply_box_blur!(((sizes[2] - 1) // 2).to_i)

    self
  end
end

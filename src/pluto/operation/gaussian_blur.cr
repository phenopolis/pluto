module Pluto::Operation::GaussianBlur
  def gaussian_blur(value : Int32) : Image
    clone.gaussian_blur!(value)
  end

  def gaussian_blur!(value : Int32) : Image
    sigma = value
    n = 3

    w_ideal = Math.sqrt((12 * sigma * sigma / n) + 1)
    w_l = w_ideal.floor
    w_l -= 1 if w_l % 2 == 0

    m_ideal = (12 * sigma * sigma - n * w_l * w_l - 4 * n * w_l - 3 * n) / (-4 * w_l - 4)
    m = m_ideal.round

    sizes = [] of Float64
    n.times do |i|
      sizes << if i < m
        w_l
      else
        w_l + 2
      end
    end

    box_blur!(((sizes[0] - 1) // 2).to_i)
    box_blur!(((sizes[1] - 1) // 2).to_i)
    box_blur!(((sizes[2] - 1) // 2).to_i)

    self
  end
end
